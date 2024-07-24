CALL InsertProducts('{
  "products": [
    {
      "name": "Product 1",
      "description": "This is a product 1",
      "category": "Category 1",
      "image": "https://via.placeholder.com/150",
      "status": "active",
      "restrictions": [
        {
          "type": "age",
          "value": 18,
          "subType": "min"
        },
        {
          "type": "age",
          "value": 60,
          "subType": "max"
        },
        {
          "type": "qty",
          "value": 2,
          "subType": "max"
        }
      ],
      "tags": [
        "tag1",
        "tag2"
      ],
      "types": [
        {
          "id": 1,
          "name": "Type 1",
          "price": 100,
          "status": "active",
          "currency": "USD",
          "distributions": [
            {
              "id": 1,
              "name": "Supplier",
              "amount": 50
            },
            {
              "id": 2,
              "name": "Seller",
              "amount": 30
            },
            {
              "id": 3,
              "name": "Platform",
              "amount": 15
            },
            {
              "id": 4,
              "name": "Delivery",
              "amount": 5
            }
          ]
        }
      ]
    }
  ]
}');
