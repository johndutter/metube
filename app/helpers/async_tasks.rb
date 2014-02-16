module AsyncTasks
  class VideoTranscodingJob < Struct.new(:videoPath, :fileName)

    attr_accessor :newFilePath

    def before

    end

    # convert to mp4 using default options
    def perform
      video = FFMPEG::Movie.new(self[:videoPath])
      @newFilePath = 'public/uploads/' + self[:fileName]  + '.mp4'
      video.transcode('public/uploads/' +self[:fileName] + '.mp4' ) {|progress| puts progress}
    end

    def error

    end

    def after

    end

    # update file path, delete old file
    def success
      Multimedia.delete_media(self[:videoPath])
      multimedia = Multimedia.find(self[:fileName])

      multimedia.update(path: @newFilePath)

    #record errors in db if rescue is needed.
    rescue ApplicationHelper::FileDeleteError
    # make some update to db?  schedule file deletion for later? 
    rescue ActiveRecord::RecordNotFound
    # do something
    end

    def failure

    end

  end
end