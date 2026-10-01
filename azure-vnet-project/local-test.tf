resource "local_file" "vienna_confirmation" {
  content  = "Week 2 Day 1: Simulation locale rejouee et validee avec succes par Moncef !"
  filename = "${path.module}/vienna-success.txt"
}

