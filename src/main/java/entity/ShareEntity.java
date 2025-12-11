package entity;

import java.util.Date;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "Shares")
public class ShareEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "emails", columnDefinition = "nvarchar(MAX)")
	private String emails;

	@Column(name = "shareDate")
	@Temporal(TemporalType.DATE)
	private Date shareDate = new Date();

	// QUAN TRỌNG: Share thuộc về User
	@ManyToOne
	@JoinColumn(name = "user_Id")
	private UserEntity user;

	// QUAN TRỌNG: Share thuộc về Video
	@ManyToOne
	@JoinColumn(name = "video_Id")
	private VideoEntity video;
}