#!/bin/bash

# Base URL
URL="http://localhost:4567"

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}1. Health check...${NC}"
curl -s "$URL/"
echo ""
echo ""

echo -e "${GREEN}2. Creating user 1...${NC}"
curl -s -X POST "$URL/users" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'
echo ""
echo ""

echo -e "${GREEN}3. Creating user 2...${NC}"
curl -s -X POST "$URL/users" \
  -H "Content-Type: application/json" \
  -d '{"name": "Jane Smith", "email": "jane@example.com"}'
echo ""
echo ""

echo -e "${GREEN}4. Getting all users...${NC}"
curl -s "$URL/users"
echo ""
echo ""

echo -e "${GREEN}5. Getting user 1...${NC}"
curl -s "$URL/users/1"
echo ""
echo ""

echo -e "${GREEN}6. Deleting user 2...${NC}"
curl -s -X DELETE "$URL/users/2"
echo ""
echo ""

echo -e "${GREEN}7. Getting all users (after delete)...${NC}"
curl -s "$URL/users"
echo ""
