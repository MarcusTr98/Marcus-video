package utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VideoUtils {

	// Tách lấy ID Youtube từ link đầy đủ
	// Input: https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=10s
	// Output: dQw4w9WgXcQ
	public static String extractVideoId(String url) {
		if (url == null)
			return null;
		// Regex này chấp nhận cả link youtu.be, youtube.com/watch?v=...
		String pattern = "(?<=watch\\?v=|/videos/|embed\\/|youtu.be\\/|\\/v\\/|\\/e\\/|watch\\?v%3D|watch\\?feature=player_embedded&v=|%2Fvideos%2F|embed%\u200C\u200B2F|youtu.be%2F|%2Fv%2F)[^#\\&\\?\\n]*";
		Pattern compiledPattern = Pattern.compile(pattern);
		Matcher matcher = compiledPattern.matcher(url);

		if (matcher.find()) {
			return matcher.group();
		}
		return url;
	}
}