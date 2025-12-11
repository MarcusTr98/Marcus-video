package utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtils {

	// Tạo và gửi cookie về client
	public static void add(String name, String value, int hours, HttpServletResponse resp) {
		Cookie cookie = new Cookie(name, value);
		cookie.setMaxAge(hours * 60 * 60); // Đổi giờ ra giây
		cookie.setPath("/"); // Quan trọng: để cookie dùng được cho toàn bộ website
		resp.addCookie(cookie);
	}

	// Lấy giá trị cookie gửi từ client
	public static String get(String name, HttpServletRequest req) {
		Cookie[] cookies = req.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equalsIgnoreCase(name)) {
					return cookie.getValue();
				}
			}
		}
		return ""; // Không tìm thấy trả về chuỗi rỗng
	}
}