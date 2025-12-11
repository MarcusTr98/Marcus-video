package utils;

import org.mindrot.jbcrypt.BCrypt;

public class TestPassword {
	public static void main(String[] args) {
		String rawPassword = "123";
		
		// BCrypt.gensalt(12): Tạo ra một chuỗi ngẫu nhiên (Salt) với độ phức tạp là 12 (Log rounds)
		// Số 12 càng cao thì băm càng lâu (chống Brute-force), nhưng server tốn CPU hơn.
		// BCrypt.hashpw(...): Trộn "123" với "Salt" rồi băm ra.
		// Kết quả encoded: $2a$12$R9h/cIPz0gi.URNNX3kh2OPST9/PgBkBfd... (Luôn bắt đầu bằng $2a$)
		String encoded = BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));
		
		System.out.println("Password gốc: " + rawPassword);
		System.out.println("Password đã băm (Lưu vào DB): " + encoded);
		
		// BCrypt.checkpw(input, hash)
		// B1: Nó tự tách lấy cái "Salt" nằm trong chuỗi hash ($2a$12$R9h/cIPz0gi...)
		// B2: Nó lấy input "123" trộn với Salt đó, băm lại.
		// B3: So sánh kết quả mới băm với chuỗi hash cũ. Khớp thì trả về true.
		String inputLogin = "123";
		boolean isMatch = BCrypt.checkpw(inputLogin, encoded);
		System.out.println("User nhập '123' có khớp không? -> " + isMatch);
		
		String inputWrong = "1234";
		boolean isMatchWrong = BCrypt.checkpw(inputWrong, encoded);
		System.out.println("User nhập '1234' có khớp không? -> " + isMatchWrong);
	}
}	
