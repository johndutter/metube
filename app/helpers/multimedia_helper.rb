require 'rubygems'
require 'streamio-ffmpeg'

module MultimediaHelper
  include AsyncTasks

	def generateThumbnail(videoPath)
	   video = FFMPEG::Movie.new(videoPath)
        #choose frame a third of the way through as thumbnail
        seek_time = video.duration / 3
        thumbnail_path = '/uploads/thumbnails/' + videoPath.split('/').last {} + '.jpg'

        #raises FFMPEG::Error on failure scale="'if(gt(a,4/3),320,-1)':'if(gt(a,4/3),-1,240)'"
        video.screenshot( 'public/' + thumbnail_path, { seek_time: seek_time, custom: '-vf "scale=\'if(lt(a,200/120),200,-1)\':\'if(lt(a,200/120),-1,120)\', crop=200:120"' } )
        return thumbnail_path
	end

  def generateImageThumbnail(imagePath)
    img = Magick::Image::read(imagePath).first
    thumbnail_path = '/uploads/thumbnails/' + imagePath.split('/').last {} + '.jpg'
    thumb = img.resize_to_fill(200, 120)
    thumb.write('public/' + thumbnail_path)

    return thumbnail_path
  end

	#call store_media after completion
	def transcode_avi_to_mp4(videoPath, fileName)
  	  Delayed::Job.enqueue( AsyncTasks::VideoTranscodingJob.new(videoPath, fileName), {:priority => 0, :run_at => 10.seconds.from_now.getutc} )
        return true
	end

end
