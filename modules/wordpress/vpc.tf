resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.org}-${var.app}-${var.env}-vpc"
  }
}

data "aws_availability_zones" "az" {
  state = "available"
  filter {
    name   = "region-name"
    values = [data.aws_region.current.name]
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = format("%s-%s-%s", "${var.org}-${var.app}-${var.env}-public", "subnet", count.index + 1)
      "zone" = element(var.azs, count.index)
      "Tier" = "Public"
    },
    var.tags
  )
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public.*.id
  dynamic "egress" {
    for_each = var.public_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.public_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        "${var.org}-${var.app}-${var.env}-public",
        "nacl"
      )
    },
    var.tags
  )
  depends_on = [aws_subnet.public]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" = "${var.org}-${var.app}-${var.env}-igw"
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    {
      "Name" = "${var.org}-${var.app}-${var.env}-public-rt"
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = format("%s-%s-%s", "${var.org}-${var.app}-${var.env}-private", "subnet", count.index + 1)
      "zone" = element(var.azs, count.index)
      "Tier" = "Private"
    },
    var.tags
  )
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private.*.id
  dynamic "egress" {
    for_each = var.private_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.private_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        "${var.org}-${var.app}-${var.env}-private",
        "nacl"
      )
    },
    var.tags
  )
  depends_on = [aws_subnet.private]
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.org}-${var.app}-${var.env}-private-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(
    {
      "Name" = "${var.org}-${var.app}-${var.env}-private-rt"
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private.*.id)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "db" {
  count                   = length(var.database_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.database_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = format("%s-%s-%s", "${var.org}-${var.app}-${var.env}-db", "subnet", count.index + 1)
      "zone" = element(var.azs, count.index)
      "Tier" = "Data"
    },
    var.tags
  )
}

resource "aws_network_acl" "db" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.db.*.id

  dynamic "ingress" {
    for_each = toset(var.private_subnets)
    content {
      action     = "allow"
      cidr_block = ingress.value
      from_port  = var.db_port
      protocol   = "tcp"
      to_port    = var.db_port
      rule_no    = 110 + index(var.private_subnets, ingress.value)
    }
  }

  dynamic "egress" {
    for_each = toset(var.private_subnets)
    content {
      action     = "allow"
      cidr_block = egress.value
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      rule_no    = 110 + index(var.private_subnets, egress.value)
    }
  }

  dynamic "egress" {
    for_each = var.db_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.db_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        "${var.org}-${var.app}-${var.env}-db",
        "nacl"
      )
    },
    var.tags
  )
  depends_on = [aws_subnet.private]
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" = "${var.org}-${var.app}-${var.env}-private-rt"
    },
    var.tags
  )
}

resource "aws_route_table_association" "db" {
  count          = length(aws_subnet.db.*.id)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}