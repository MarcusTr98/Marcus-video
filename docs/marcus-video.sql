
USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Marcus_video')
BEGIN
    DROP DATABASE Marcus_video
END
GO

CREATE DATABASE Marcus_video
GO

USE Marcus_video
GO

/* 1. BẢNG USERS */
CREATE TABLE Users(
	id nvarchar(20) not null primary key,
	[password] varchar(100) not null, 
	fullname nvarchar(50) not null,
	email nvarchar(50) not null UNIQUE,
	avatar varchar(255),
	gender bit DEFAULT 1, 
	[admin] bit DEFAULT 0,
	isActive BIT DEFAULT 1 NOT NULL,
	createdDate DATETIME DEFAULT GETDATE()
)
GO

/* 2. BẢNG VIDEOS */
CREATE TABLE Videos(
	id char(11) not null primary key,
	title nvarchar(100) not null,
	poster nvarchar(255),
	[description] nvarchar(MAX),
	active bit DEFAULT 1,
	views int DEFAULT 0
)
GO

/* 3. BẢNG FAVORITES */
CREATE TABLE Favorites(
	id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	user_Id NVARCHAR(20) NOT NULL,
	video_Id CHAR(11) NOT NULL,
	likeDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (user_Id) REFERENCES Users(id) ON DELETE CASCADE,
	FOREIGN KEY (video_Id) REFERENCES Videos(id) ON DELETE CASCADE,
	UNIQUE(user_Id, video_Id) 
)
GO

/* 4. BẢNG SHARES */
CREATE TABLE Shares(
	id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	user_Id NVARCHAR(20) NOT NULL,
	video_Id CHAR(11) NOT NULL,
	emails NVARCHAR(MAX) NOT NULL,
	shareDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (user_Id) REFERENCES Users(id) ON DELETE CASCADE,
	FOREIGN KEY (video_Id) REFERENCES Videos(id) ON DELETE CASCADE
)
GO

/* 5. BẢNG HISTORY */
CREATE TABLE History(
	id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	user_Id NVARCHAR(20) NOT NULL,
	video_Id CHAR(11) NOT NULL,
	viewDate DATETIME DEFAULT GETDATE(),
	isLiked BIT DEFAULT 0, 
	likedDate DATETIME NULL,
	FOREIGN KEY (user_Id) REFERENCES Users(id) ON DELETE CASCADE,
	FOREIGN KEY (video_Id) REFERENCES Videos(id) ON DELETE CASCADE,
	UNIQUE(user_Id, video_Id) 
)
GO

/* --- DATA SEEDING (DỮ LIỆU MẪU) --- */
-- Users
INSERT INTO Users(id, password, fullname, email, avatar, admin, gender, isActive) VALUES 
('admin',  '$2a$12$ac89cALBILNteXBSMY7OqewjiW9uw19Fqj82VooBvSa.CM/m/W412', N'Marcus Admin',   'admin@marcus.com',      'https://ui-avatars.com/api/?name=Marcus+Admin&background=random', 1, 1, 1),
('user01', '$2a$12$cn9A2ReGr8DTTwCO7Qv6g.BMWKyr1/H4LU.0OdeZOuFmUgjkDLbmq', N'Nguyễn Văn An',  'an.nguyen@gmail.com',   'https://ui-avatars.com/api/?name=Nguyen+Van+An&background=random', 0, 1, 1),
('user02', '$2a$12$Vm9IUrL8Asf57ZcWYJvV.OxoozJ6RXgaM8/hWdzvQecJUWAshjGZq', N'Trần Thị Bảo',  'bao.tran@gmail.com',   'https://ui-avatars.com/api/?name=Tran+Thi+Bao&background=random', 0, 0, 1),
('user03', '$2a$12$wc6ZsrLL/rvAbUPT4IhbLOZKkzQTSPzeOR8lbtKDSsi72C0ZrKTmK', N'Lê Văn Cường',   'cuong.le@yahoo.com',    'https://ui-avatars.com/api/?name=Le+Van+Cuong&background=random', 0, 1, 1),
('user04', '$2a$12$dBrvQi4oFJEK1GdPrFfaB.kGN2vcQv2A.jRTs15AP5vVLBnEzhYRm', N'Phạm Thị Dung',  'dung.pham@outlook.com', 'https://ui-avatars.com/api/?name=Pham+Thi+Dung&background=random', 0, 0, 1),
('user05', '$2a$12$.uJS7ZCk.PATT2OJZmR8fup3PKpGP5.c7hcwhwxACGEbhj4jcqmoe', N'Hoàng Văn Em',   'em.hoang@gmail.com',    'https://ui-avatars.com/api/?name=Hoang+Van+Em&background=random', 0, 1, 1),
('user06', '$2a$12$oeSWWXE3DNwYFLJQ94v/vOvBCTzCH/B5lcduuweAm3dgAft9K500G', N'Vũ Thị Phương',  'phuong.vu@gmail.com',   'https://ui-avatars.com/api/?name=Vu+Thi+Phuong&background=random', 0, 0, 1),
('user07', '$2a$12$khPXHpJRogo3cweLzLAWoeE164TRFTIz61LH0pH1h8YhKkcRuNQkm', N'Đặng Văn Giang', 'giang.dang@poly.edu.vn','https://ui-avatars.com/api/?name=Dang+Van+Giang&background=random', 0, 1, 1),
('user08', '$2a$12$RUit9A1or9wzvF.OKEFADeG4AIvIdVd9jj0Ray8o6hzQsU7VtBFzS', N'Bùi Thị Hương',  'huong.bui@fpt.edu.vn',  'https://ui-avatars.com/api/?name=Bui+Thi+Huong&background=random', 0, 0, 1),
('user09', '$2a$12$5FnffUYOGOn/aB7D1Pn2Je3Gr7FwWTd46mKbBmO3Fqcr/.SYg2qTm', N'Đỗ Văn Ích',     'ich.do@gmail.com',      'https://ui-avatars.com/api/?name=Do+Van+Ich&background=random', 0, 1, 1),
('user10', '$2a$12$ZF92T2KozgpK4pBT44AW2usDQ1v9U2bkNhpBjOA4lI5ZdjBKl3JPC', N'Ngô Thị Kim',    'kim.ngo@gmail.com',     'https://ui-avatars.com/api/?name=Ngo+Thi+Kim&background=random', 0, 0, 1),
('user11', '$2a$12$MUZ8Vzu9PHTabwgfUm3bQ.qOmL/CFgv71ZfEqZmltmV4iWXiNkb9a', N'Lý Văn Long',    'long.ly@gmail.com',     'https://ui-avatars.com/api/?name=Ly+Van+Long&background=random', 0, 1, 1),
('user12', '$2a$12$Tr/31e7/f.MDtKeKnWrJ.e4bS.DWsEqhqyvmFiRQIHYzgcXgiSMfO', N'Mai Thị Mơ',     'mo.mai@gmail.com',      'https://ui-avatars.com/api/?name=Mai+Thi+Mo&background=random', 0, 0, 1);
GO

select * from users
-- Videos
INSERT INTO Videos(id, title, poster, [description], active, views) VALUES
('9sT_h7q7lII', N'Java Spring Boot Full Course', 'https://img.youtube.com/vi/9sT_h7q7lII/maxresdefault.jpg', N'Khóa học Java Spring Boot đầy đủ từ A-Z.', 1, 1500),
('M7lc1UVf-VE', N'Spring Boot Tutorial for Beginners', 'https://img.youtube.com/vi/M7lc1UVf-VE/maxresdefault.jpg', N'Học Spring Boot cơ bản trong 1 giờ.', 1, 2300),
('GoXwIVyNvX0', N'Java Full Course for free', 'https://img.youtube.com/vi/GoXwIVyNvX0/maxresdefault.jpg', N'Học Java Core miễn phí cùng Bro Code.', 1, 5000),
('dQw4w9WgXcQ', N'Rick Astley - Never Gonna Give You Up', 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg', N'Bài hát huyền thoại.', 1, 99999),
('kJQP7kiw5Fk', N'Luis Fonsi - Despacito ft. Daddy Yankee', 'https://img.youtube.com/vi/kJQP7kiw5Fk/maxresdefault.jpg', N'Video ca nhạc tỷ view.', 1, 45000),
('OPf0YbXqDm0', N'Mark Ronson - Uptown Funk', 'https://img.youtube.com/vi/OPf0YbXqDm0/maxresdefault.jpg', N'Nhạc funk sôi động.', 1, 32000),
('09R8_2nJtjg', N'Maroon 5 - Sugar', 'https://img.youtube.com/vi/09R8_2nJtjg/maxresdefault.jpg', N'Maroon 5 đi hát đám cưới.', 1, 28000),
('JfVOs4VSpmA', N'SPIDER-MAN: NO WAY HOME', 'https://img.youtube.com/vi/JfVOs4VSpmA/maxresdefault.jpg', N'Trailer phim Người Nhện.', 1, 12000),
('KPLWWIOCOOQ', N'Game of Thrones - Season 1 Trailer', 'https://img.youtube.com/vi/KPLWWIOCOOQ/maxresdefault.jpg', N'Huyền thoại phim truyền hình.', 1, 8000),
('TcMBFSGVi1c', N'Avengers: Endgame', 'https://img.youtube.com/vi/TcMBFSGVi1c/maxresdefault.jpg', N'Hồi kết Marvel.', 1, 55000),
('5qap5aO4i9A', N'Lofi Girl - beats to relax/study to', 'https://img.youtube.com/vi/5qap5aO4i9A/maxresdefault.jpg', N'Nhạc Lofi chill.', 1, 1000),
('ysz5S6P_z-E', N'Louis Armstrong - What A Wonderful World', 'https://img.youtube.com/vi/ysz5S6P_z-E/maxresdefault.jpg', N'Một thế giới tuyệt vời.', 0, 500);
GO

-- Favorites
INSERT INTO Favorites(user_Id, video_Id, likeDate) VALUES
('user01', 'dQw4w9WgXcQ', '2023-11-20'), ('user02', 'dQw4w9WgXcQ', '2023-11-22'), ('user03', 'dQw4w9WgXcQ', '2023-11-23'), ('user04', 'dQw4w9WgXcQ', '2023-11-24'), ('user05', 'dQw4w9WgXcQ', '2023-11-25'),
('user02', 'kJQP7kiw5Fk', '2023-12-01'), ('user03', 'kJQP7kiw5Fk', '2023-12-02'), ('admin',  'kJQP7kiw5Fk', '2023-12-03'),
('user01', 'M7lc1UVf-VE', '2023-12-05'), ('user07', 'M7lc1UVf-VE', '2023-12-05'), ('user09', 'M7lc1UVf-VE', '2023-12-05'), ('user11', 'M7lc1UVf-VE', '2023-12-05'), ('admin',  'M7lc1UVf-VE', '2023-12-05'),
('user06', '09R8_2nJtjg', '2023-10-10'), ('user08', '09R8_2nJtjg', '2023-10-11'), ('user10', '09R8_2nJtjg', '2023-10-12'), ('user12', '09R8_2nJtjg', '2023-10-13'),
('user01', 'TcMBFSGVi1c', '2023-09-09'), ('user02', 'TcMBFSGVi1c', '2023-09-09'), ('user03', 'TcMBFSGVi1c', '2023-09-09'), ('user04', 'TcMBFSGVi1c', '2023-09-09'), ('user05', 'TcMBFSGVi1c', '2023-09-09'),
('user12', '5qap5aO4i9A', GETDATE());
GO

-- Shares
INSERT INTO Shares(user_Id, video_Id, emails, shareDate) VALUES
('user01', '9sT_h7q7lII', 'ban1@gmail.com, ban2@gmail.com', '2025-12-01'),
('user01', 'dQw4w9WgXcQ', 'troll@gmail.com', '2025-12-02'),
('user02', 'kJQP7kiw5Fk', 'musiclover@yahoo.com', '2024-12-03'),
('user03', 'M7lc1UVf-VE', 'student@poly.edu.vn', '2025-12-04'),
('user04', '09R8_2nJtjg', 'wedding@gmail.com', '2025-12-05'),
('admin',  '9sT_h7q7lII', 'staff@marcus.com', '2025-12-06'),
('user05', 'TcMBFSGVi1c', 'fanmarvel@gmail.com', '2025-12-07'),
('user06', '5qap5aO4i9A', 'studygroup@zalo.me', '2025-12-08'),
('user07', 'GoXwIVyNvX0', 'classmate@fpt.edu.vn', '2025-12-09'),
('user08', 'JfVOs4VSpmA', 'moviefan@outlook.com', '2025-12-10'),
('user09', 'KPLWWIOCOOQ', 'winteriscoming@gmail.com', '2025-12-11'),
('user10', 'OPf0YbXqDm0', 'dance@club.com', '2025-12-12'),
('user11', 'ysz5S6P_z-E', 'oldmusic@classic.com', '2025-12-13'),
('user12', 'dQw4w9WgXcQ', 'victim2@gmail.com', '2025-12-14'),
('admin',  'dQw4w9WgXcQ', 'victim3@gmail.com', '2025-12-15');
GO