resource "aws_efs_file_system" "efs" {
   creation_token = "efs"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "EFS"
   }
 }


resource "aws_efs_mount_target" "efs-mt" {
   count = length(data.aws_availability_zones.available.names)
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = [private_data_subnet_az1_id , private_data_subnet_az2_id]
   security_groups = [var.efs_security_group_id]
 }






