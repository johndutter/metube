require 'rubygems'
require 'streamio-ffmpeg'

module MultimediaHelper
  include AsyncTasks

	def generateThumbnail(videoPath)
	   video = FFMPEG::Movie.new(videoPath)
        #choose frame a third of the way through as thumbnail
        seek_time = video.duration / 3
        thumbnail_path = 'uploads/thumbnails/' + videoPath.split('/').last {} + '.jpg'

        #raises FFMPEG::Error on failure
        video.screenshot( 'public/' + thumbnail_path, seek_time: seek_time, resolution: '200x120' )
        return thumbnail_path
	end

	#call store_media after completion
	def transcode_avi_to_mp4(videoPath, fileName)
  	  Delayed::Job.enqueue( AsyncTasks::VideoTranscodingJob.new(videoPath, fileName), {:priority => 0, :run_at => 10.seconds.from_now.getutc} )
        return true
	end

end
