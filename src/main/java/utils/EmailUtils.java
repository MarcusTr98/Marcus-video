package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtils {

    // Cấu hình Server Gmail (Giữ nguyên)
    private static final String HOST_NAME = "smtp.gmail.com";
    private static final int TSL_PORT = 587;

    // TODO: [QUAN TRỌNG] Các bạn hãy thay email & mật khẩu ứng dụng của mình vào đây để chạy thử nhé!
    // Hướng dẫn: https://support.google.com/accounts/answer/185833
    private static final String APP_EMAIL = "YOUR_EMAIL_HERE"; 
    private static final String APP_PASSWORD = "YOUR_APP_PASSWORD_HERE";

    public static void sendEmail(String toAddress, String subject, String body) throws MessagingException {
        // ... (Phần code logic bên dưới giữ nguyên không cần sửa) ...
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST_NAME);
        props.put("mail.smtp.port", TSL_PORT);
        props.put("mail.smtp.ssl.trust", HOST_NAME);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(APP_EMAIL, APP_PASSWORD);
            }
        });
        
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(APP_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
        message.setSubject(subject);
        message.setContent(body, "text/html; charset=UTF-8");
        
        Transport.send(message);
        // Bỏ dòng System.out.println hoặc log cẩn thận để không lộ thông tin
    }
}
