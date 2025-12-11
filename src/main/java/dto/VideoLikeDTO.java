package dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class VideoLikeDTO {
	private String status; // "success" hoặc "fail"
	private Integer totalLikes; // Tổng số like mới
	private Boolean isLiked;
	private Date time;

	public VideoLikeDTO(String status, Integer totalLikes, Boolean isLiked) {
		this.status = status;
		this.totalLikes = totalLikes;
		this.isLiked = isLiked;
		this.time = new Date();
	}

}
