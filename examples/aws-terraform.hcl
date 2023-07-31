module "kubernetes" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.20"
  subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  vpc_id          = "vpc-abcde012"

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1

      instance_type = "m5.large"
      key_name      = "my-key"
    }
  }
}

module "kafka" {
  source  = "airasia/kafka/aws"
  version = "1.0.0"

  name_prefix   = "my-kafka"
  vpc_id        = "vpc-abcde012"
  subnet_ids    = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  instance_type = "m5.large"
  kafka_version = "2.4.1"
  number_of_broker_nodes = 3
}

resource "kubernetes_deployment" "GenomePhone" {
  metadata {
    name = "genomephone-deployment"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "GenomePhone"
      }
    }

    template {
      metadata {
        labels = {
          App = "GenomePhone"
        }
      }

      spec {
        container {
          image = "ghcr.io/genomephone/genomephone-frontend:latest"
          name  = "genomephone-frontend"

          port {
            container_port = 8000
          }
        }
      }
    }
  }
}