echo "Enter username: "
read username
useradd "$username"
echo "temp4now" | passwd --stdin "$username"
chage -d 0 "$username"