package entity;

import java.util.Date;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "Favorites", uniqueConstraints = { @UniqueConstraint(columnNames = { "user_Id", "video_Id" }) })
public class FavoriteEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "user_Id")
	private UserEntity user;

	@ManyToOne
	@JoinColumn(name = "video_Id")
	private VideoEntity video;

	@Column(name = "likeDate")
	@Temporal(TemporalType.DATE)
	private Date likeDate = new Date();

}