package entity;

import java.util.Date;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "History")
public class HistoryEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "user_Id")
	private UserEntity user;

	@ManyToOne
	@JoinColumn(name = "video_Id")
	private VideoEntity video;

	@Column(name = "viewDate")
	@Temporal(TemporalType.TIMESTAMP)
	private Date viewDate = new Date();

	@Column(name = "isLiked")
	private Boolean isLiked = false;

	@Column(name = "likedDate")
	private Date likedDate;
}