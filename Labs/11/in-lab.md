## Q1
```js
use inventoryDB
switched to db inventoryDB
db.furniture.insertMany([
  { name: "Table", color: "Brown", dimensions: [40, 80] },
  { name: "Chair", color: "Black", dimensions: [20, 20] },
  { name: "Sofa", color: "Grey", dimensions: [60, 200] }
]);
```
<img width="527" height="237" alt="image" src="https://github.com/user-attachments/assets/d94ad900-c234-4e1a-b565-66aaae6ece61" />

## Q2
```js
db.furniture.insertOne({
  name: "Desk",
  color: "Brown",
  dimensions: [50, 100]
});
```
<img width="577" height="117" alt="image" src="https://github.com/user-attachments/assets/12c34102-fb9f-4831-bb35-2390f64957d6" />

## Q3
```js
db.furniture.find({
  "dimensions.0": { $gt: 30 }
});
```
<img width="616" height="816" alt="image" src="https://github.com/user-attachments/assets/d346c328-2704-42fd-a5a7-d5651a7bb5e6" />

## Q4
```js
db.furniture.find({
  color: "Brown",
  name: { $in: ["Table", "Chair"] }
});
```
<img width="527" height="267" alt="image" src="https://github.com/user-attachments/assets/915ceeab-0c08-45b8-bc85-3b5fe8876739" />

## Q5
```js
db.furniture.updateOne(
  { name: "Table" },
  { $set: { color: "Ivory" } }
);
```
<img width="442" height="212" alt="image" src="https://github.com/user-attachments/assets/4438fb36-7bbc-4330-97d4-9c42de0d7246" />

# Q6
```js
db.furniture.updateMany(
  { color: "Brown" },
  { $set: { color: "Dark Brown" } }
);
```
<img width="451" height="207" alt="image" src="https://github.com/user-attachments/assets/b37767fc-35c8-46ea-8c1f-501835fa2eba" />

## Q7
```js
db.furniture.deleteOne({ name: "Chair" });
```
<img width="582" height="126" alt="image" src="https://github.com/user-attachments/assets/356c28d5-63b9-4008-b7f3-fb932c943b3b" />

## Q8
```js
db.furniture.deleteMany({ dimensions: [12, 18] });
```
<img width="622" height="122" alt="image" src="https://github.com/user-attachments/assets/5e979260-42f5-4117-9fa5-365fcdf30c8a" />

## Q9
```js
db.furniture.aggregate([
  { $group: { _id: "$color", total_items: { $sum: 1 } } }
]);
```
<img width="456" height="365" alt="image" src="https://github.com/user-attachments/assets/52a373a2-a901-414d-a171-9177c501b7c0" />

## Q10
```js
db.furniture.createIndex({ name: "text" });
db.furniture.find({
  $text: { $search: "table" }
});
```
<img width="652" height="422" alt="image" src="https://github.com/user-attachments/assets/9d6bae54-7d63-468c-8c7b-10021e602fea" />
