package entity;

import java.util.List;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "Videos")
public class VideoEntity {
	@Id
	@Column(name = "id")
	private String id;

	@Column(name = "title", columnDefinition = "nvarchar(MAX)")
	private String title;

	@Column(name = "poster")
	private String poster;

	@Column(name = "description", columnDefinition = "nvarchar(MAX)")
	private String description;

	@Column(name = "active")
	private Boolean active;

	@Column(name = "views")
	private Integer views;

	@OneToMany(mappedBy = "video", fetch = FetchType.EAGER)
	private List<FavoriteEntity> favorites;

	@OneToMany(mappedBy = "video", fetch = FetchType.LAZY)
	private List<ShareEntity> shares;
}