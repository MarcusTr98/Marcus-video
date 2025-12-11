package entity;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

@Entity
@Table(name = "Users")

public class UserEntity {

	@Id
	@Column(name = "id", length = 20, nullable = false)
	private String id;

	@Column(name = "password", length = 100, nullable = false)
	private String password;

	@Column(name = "fullname", length = 50, nullable = false)
	private String fullname;

	@Column(name = "email", unique = true)
	private String email;

	@Column(name = "avatar")
	private String avatar;

	@Column(name = "gender", nullable = true)
	private Boolean gender = false;

	@Column(name = "admin", nullable = false)
	private Boolean admin = false;

	@OneToMany(mappedBy = "user")
	private List<FavoriteEntity> favorites;

	@OneToMany(mappedBy = "user")
	private List<ShareEntity> shares;

}
