module AsyncTasks
  class VideoTranscodingJob < Struct.new(:videoPath, :multimedia_id)

    attr_accessor :newFilePath, :regex_pattern

    #set multimedia id in DJ table
    def before
      #match delayed job whose handler contains :multimedia_id
      @regex_pattern = "\'" + self[:multimedia_id].to_s + "\'" 
      # SELECT * FROM delayed_jobs WHERE handler REGEXP <regex_pattern>;
      delayed_job = DelayedJob.where("handler REGEXP ?", @regex_pattern).to_a[0]
      # UPDATE delayed_jobs SET multimedia_id = <multimedia_id> WHERE id = <id>;
      delayed_job.update(multimedia_id: self[:multimedia_id])
    end

    # convert to mp4 using default options
    def perform
      video = FFMPEG::Movie.new(self[:videoPath])
      @newFilePath = '/uploads/' + self[:multimedia_id].to_s  + '.mp4'
      # SELECT * FROM delayed_jobs WHERE handler REGEXP <regex_pattern>;
      delayed_job = DelayedJob.where("handler REGEXP ?", @regex_pattern).to_a[0]

      video.transcode( (File.expand_path File.dirname(__FILE__)) + '/../../public/uploads/' + self[:multimedia_id].to_s + '.mp4' ) do |progress| 
        # progress is decimal so multiply by 100 for percentage
        percentage_complete = progress * 100
        # UPDATE delayed_jobs SET job_progress=<progress> WHERE delayed_job_id = <delayed_job_id>
        delayed_job.update(job_progress: percentage_complete)
      end
    end

    # update file path, delete old file
    def success
      Multimedia.delete_media(self[:videoPath])
      # SELECt * FROM multimedia WHERE multimedia_id = <multimedia_id>
      multimedia = Multimedia.find(self[:multimedia_id])

      # UPDATE multimedia SET path = <path> WHERE id = <id>;
      multimedia.update(path: @newFilePath)

    #log error if there is failiure after successful transcodde
    rescue ApplicationHelper::FileDeleteError
      # log the error
      Rails.logger.info 'Error deleting file after successful transcoding.'
    rescue ActiveRecord::RecordNotFound
      Rails.logger.info 'Error finding record in database after successful transcoding.'
    end

  end
end