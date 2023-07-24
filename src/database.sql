-- bài 2: 
-- Hiển thị toàn bộ nội dung của bảng Architect ;
SELECT * FROM `architect`;
-- Hiển thị danh sách gồm họ tên và giới tính của kiến trúc sư :
SELECT name,sex FROM `architect`;
-- Hiển thị những năm sinh có thể có của các kiến trúc sư:
SELECT birthday FROM `architect`;
-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh tăng dần)
SELECT birthday FROM `architect` ORDER BY birthday ASC;
-- Hiển thị danh sách các kiến trúc sư (họ tên và năm sinh) (giá trị năm sinh giảm dần)
SELECT name, birthday FROM `architect` ORDER BY birthday DESC;
-- Hiển thị danh sách các công trình có chi phí từ thấp đến cao.
-- Nếu 2 công trình có chi phí bằng nhau sắp xếp tên thành phố theo bảng chữ cái building
SELECT name,city,cost FROM `building` ORDER BY cost ASC;

--bài 4 :
-- Hiển thị tất cả thông tin của kiến trúc sư "le thanh tung"
SELECT * FROM `architect` WHERE id = 1;
-- Hiển thị tên, năm sinh các công nhân có chuyên môn hàn hoặc điện
SELECT name,birthday,skill FROM `worker` WHERE skill='han' OR skill='dien';
-- Hiển thị tên các công nhân có chuyên môn hàn hoặc điện và năm sinh lớn hơn 1948
SELECT * FROM `worker` WHERE skill='han' OR skill='dien'AND birthday > 1948;
-- Hiển thị những công nhân bắt đầu vào nghề khi dưới 20 (birthday + 20 > year):
SELECT * FROM worker WHERE birthday + 20 > year;
-- Hiển thị những công nhân có năm sinh 1945, 1940, 1948
SELECT * FROM `worker` WHERE birthday = 1945 OR birthday = 1940 OR birthday = 1948;
-- Tìm những công trình có chi phí đầu tư từ 200 đến 500 triệu đồng:
SELECT * FROM `building` WHERE cost >= 200 AND cost < 500;
-- Tìm kiếm những kiến trúc sư có họ là nguyen: % chuỗi
SELECT * FROM architect WHERE name LIKE '%Nguy%';
-- Tìm kiếm những kiến trúc sư có tên đệm là anh
SELECT * FROM architect WHERE name LIKE '% anh%';
--Tìm kiếm những kiến trúc sư có tên bắt đầu th và có 3 ký tự:
SELECT * FROM `architect` WHERE name LIKE '%th_';
-- Tìm chủ thầu không có phone:
SELECT * FROM `contractor` WHERE phone IS NULL;


-- bai 5 :
-- Thống kê tổng số kiến trúc sư
SELECT COUNT(*) AS total_kien_truc_su FROM `architect`;
-- Thống kê tổng số kiến trúc sư nam
SELECT COUNT(*) AS total_kien_truc_su_nam FROM `architect` WHERE sex = 1;
-- Tìm ngày tham gia công trình nhiều nhất của công nhân
SELECT date, COUNT(worker_id) AS total_workers FROM work GROUP BY date ORDER BY total_workers DESC LIMIT 1;

-- Tìm tổng số ngày tham gia công trình của tất cả công nhân

SELECT 
    work.worker_id,
		worker.name,
    MIN(work.date) AS Ngày_Tham_Gia_Đầu_Tiên,
		COUNT(work.date) AS Tổng_Ngày_Tham_Gia
FROM 
    work
		INNER JOIN worker on work.worker_id = worker.id
GROUP BY 
    work.worker_id;


-- Tìm tổng chi phí phải trả cho việc thiết kế công trình của kiến trúc sư có Mã số 1
SELECT architect.name AS architect_name, SUM(design.benefit * 1000) AS total_salary
FROM architect 
INNER JOIN design  ON architect.id = design.architect_id
WHERE architect.id = 1;
--Tìm trung bình số ngày tham gia công trình của công nhân

-- Hiển thị thông tin kiến trúc sư: họ tên, tuổi:
SELECT name, YEAR(CURRENT_DATE()) - birthday AS Age FROM architect;
-- Tính thù lao của kiến trúc sư: Thù lao = benefit * 1000:
SELECT architect.name 
AS architect_name, SUM(design.benefit * 1000) 
AS Salary 
FROM architect 
INNER JOIN design
ON architect.id = design.architect_id 
GROUP BY architect.name;

-- Bài 6:
-- Hiển thị thông tin công trình có chi phí cao nhất:
SELECT * FROM building WHERE cost = (SELECT MAX(cost) FROM building);
-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT * FROM building WHERE city = 'can tho' AND cost = (SELECT MAX(cost) FROM building);
-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ
SELECT * FROM building WHERE cost > (SELECT MIN(cost) FROM building WHERE city = "can tho") AND NOT city="can tho";
-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế:
SELECT * FROM building LEFT OUTER JOIN designer USING (city, id) WHERE designer.designer_
--Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT * FROM `design` WHERE architect_id IS NULL;
-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp


-- Bài 07:
-- Hiển thị thù lao trung bình của từng kiến trúc sư
 SELECT architect.name AS architect_name, AVG(design.benefit * 1000) AS total_salary 
FROM architect 
INNER JOIN design ON architect.id = design.architect_id 
GROUP BY architect.name;
-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố

SELECT building.city, 
	SUM(
		building.cost * 1000 
		+ COALESCE(
			(
				SELECT SUM(design.benefit * 1000)
				FROM design
				WHERE design.building_id = building.id
			), 0)
		+ COALESCE(
			(
				SELECT SUM(work.total * 500)
				FROM work
				WHERE work.building_id = building.id
			), 0)
	) as 'Tổng Chi Phí Đầu Tư'
FROM building
GROUP BY building.city

-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
SELECT building_id, total_benefit FROM ( SELECT building_id, SUM(benefit) AS total_benefit 
FROM design 
GROUP BY building_id ) AS subquery 
WHERE total_benefit > 50;



