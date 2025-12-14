package dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class VideoStats {
	private String title;
	private long value; // Biến này dùng chung: lúc thì là Views, lúc thì là Likes
}