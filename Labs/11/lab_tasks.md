1. Create a database named SchoolDB
```js
use SchoolDB
```

2. Create two collections: Students and Courses
```js
db.createCollection("Students")
db.createCollection("Courses")
```

3. Insert the following documents into the Students collection
<img width="982" height="400" alt="image" src="https://github.com/user-attachments/assets/ca1d9706-1178-47ba-8b09-2ec6c4652908" />

4. Insert the following documents into the Courses collection
<img width="1602" height="256" alt="image" src="https://github.com/user-attachments/assets/c3118747-c08d-4ef6-9173-541d25ae88a8" />

5. Use findOne to retrieve:
a) Students with math >= 80 AND science < 90

<img width="491" height="602" alt="image" src="https://github.com/user-attachments/assets/d5c38875-4620-49b6-be4d-19cda15225ab" />

b) Course where studentsEnrolled includes 3 AND instructor = "Dr. Adams"

<img width="398" height="482" alt="image" src="https://github.com/user-attachments/assets/16ba810b-2b6d-42df-be14-c497a3540523" />

6. Use find to retrieve:
a) Students with math >= 80 AND science < 90

<img width="567" height="597" alt="image" src="https://github.com/user-attachments/assets/3acc3e5d-07db-47b9-80d2-94b40f2b1611" />

b) Students whose age < 23 OR math >= 85

<img width="673" height="178" alt="image" src="https://github.com/user-attachments/assets/7c89553f-4a14-41ab-872b-6955890a0a73" />

<img width="521" height="812" alt="image" src="https://github.com/user-attachments/assets/3fec47cf-d215-43f0-99d1-21d7bd7319d6" />

c) Students with science >= 80 AND (math < 75 OR age > 22)

<img width="687" height="201" alt="image" src="https://github.com/user-attachments/assets/a8da01b1-ebc5-4692-90fc-9d1778d43693" />

7. Use updateOne to increase Bob’s science score where math >= 75
<img width="667" height="327" alt="image" src="https://github.com/user-attachments/assets/543117d7-b731-4988-8286-4272a5f516ac" />

8. Use updateMany to increase math score by 5 for students with science < 80 AND age > 22
<img width="557" height="546" alt="image" src="https://github.com/user-attachments/assets/3885b295-f455-460a-a938-a59c2234e31c" />

9. Use deleteOne to remove Daisy where science < 80
db.Students.deleteOne({
<img width="437" height="156" alt="image" src="https://github.com/user-attachments/assets/9e796793-1820-4239-a5c1-3e0954caa28a" />

10. Use deleteMany to remove courses where studentsEnrolled includes 2 OR instructor = "Dr. Smith"
<img width="458" height="298" alt="image" src="https://github.com/user-attachments/assets/1ade73e3-f859-4fa7-bcbe-dac31df5201c" />

11. Drop the Students collection
<img width="358" height="60" alt="image" src="https://github.com/user-attachments/assets/2105b049-2d87-40ec-a2d6-a4703545a7f4" />

12. Drop the Courses collection
<img width="377" height="61" alt="image" src="https://github.com/user-attachments/assets/4d96950f-6f27-4524-bd8f-c152bb61fb90" />

13. Delete the SchoolDB database
<img width="422" height="63" alt="image" src="https://github.com/user-attachments/assets/93f116d6-76d6-4a37-97b6-2357a262940c" />

