require 'rubygems'
require 'streamio-ffmpeg'

module MultimediaHelper

	def generateThumbnail(videoPath)
		video = FFMPEG::Movie.new(videoPath)
		#choose frame a third of the way through as thumbnail
		seek_time = video.duration / 3
		thumbnail_path = 'uploads/thumbnails/' + videoPath.split('/').last {} + '.jpg'

		#raises FFMPEG::Error on failure
		video.screenshot( 'public/' + thumbnail_path, seek_time: seek_time, resolution: '200x120' )
		return thumbnail_path
	end
end
