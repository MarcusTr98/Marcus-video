package utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import entity.UserEntity;

public class EmailUtils {
	private static final String EMAIL_FROM = "echtay1102@gmail.com";
	private static final String EMAIL_PASSWORD = "dvuh hdte lhwf eexy";

	public static void send(UserEntity recipient, String newPassword) throws Exception {
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");

		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
			}
		});

		Message message = new MimeMessage(session);
		message.setFrom(new InternetAddress(EMAIL_FROM));
		message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient.getEmail()));
		message.setSubject("Marcus-Video - Mật khẩu mới của bạn");

		// Gửi mật khẩu mới (chưa hash) để người dùng đọc được
		String content = "Chào " + recipient.getFullname() + ",<br>"
				+ "Chúng tôi đã reset mật khẩu của bạn theo yêu cầu.<br>"
				+ "Mật khẩu mới của bạn là: <b style='color:red; font-size:18px;'>" + newPassword + "</b><br>"
				+ "Vui lòng đăng nhập và đổi lại mật khẩu ngay lập tức.";

		message.setContent(content, "text/html; charset=utf-8");
		Transport.send(message);
	}
}