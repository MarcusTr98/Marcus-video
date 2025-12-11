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
public class VideoLikedInfo {
	private String videoTitle;
	private Long totalLikes;
	private Date newestDate, oldestDate;

}
