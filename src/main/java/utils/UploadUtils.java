package utils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

public class UploadUtils {

	// Hàm xử lý upload và trả về đường dẫn file đã lưu
	public static String processUploadField(String fieldName, HttpServletRequest req, String storedFolder)
			throws IOException, ServletException {

		Part part = req.getPart(fieldName);

		// Kiểm tra xem người dùng có chọn file không
		if (part == null || part.getSize() <= 0) {
			return null;
		}

		// 1. Lấy tên file gốc & tạo tên mới ngẫu nhiên để tránh trùng
		String originalFileName = Path.of(part.getSubmittedFileName()).getFileName().toString();

		// Lấy đuôi file (jpg, png...)
		int dotIndex = originalFileName.lastIndexOf(".");
		String ext = (dotIndex == -1) ? "" : originalFileName.substring(dotIndex);

		// Tạo tên file mới: avatar-UUID.jpg
		String newFileName = "avatar-" + UUID.randomUUID().toString() + ext;

		// 2. Xác định thư mục lưu (webapp/uploads)
		// getRealPath trả về đường dẫn thực tế của Tomcat deploy
		String realPath = req.getServletContext().getRealPath("/" + storedFolder);

		Path uploadPath = Paths.get(realPath);

		// Nếu thư mục chưa có thì tạo mới
		if (!Files.exists(uploadPath)) {
			Files.createDirectories(uploadPath);
		}

		// 3. Lưu file
		Path filePath = uploadPath.resolve(newFileName);
		part.write(filePath.toString());

		// Trả về đường dẫn tương đối để lưu vào Database
		return storedFolder + "/" + newFileName;
	}
}