package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtils {

	// Cấu hình Email của Server (Của bạn)
	private static final String HOST_NAME = "smtp.gmail.com";
	private static final int TSL_PORT = 587;
	private static final String APP_EMAIL = "echtay1102@gmail.com"; 
	private static final String APP_PASSWORD = "dvuh hdte lhwf eexy";

	public static void sendEmail(String toAddress, String subject, String body) throws MessagingException {
		// 1. Cấu hình Properties
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", HOST_NAME);
		props.put("mail.smtp.port", TSL_PORT);
		props.put("mail.smtp.ssl.trust", HOST_NAME);

		// 2. Tạo Session xác thực
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(APP_EMAIL, APP_PASSWORD);
			}
		});

		// 3. Tạo Message
		Message message = new MimeMessage(session);
		message.setFrom(new InternetAddress(APP_EMAIL));
		message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
		message.setSubject(subject);

		// Cho phép nội dung HTML
		message.setContent(body, "text/html; charset=UTF-8");

		// 4. Gửi email
		Transport.send(message);
		System.out.println("Email sent successfully to: " + toAddress);
	}
}