# AWS EBS CSI Driver
module "ebs_csi_driver" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-ebs-csi-driver"
  version = "~> 19.0"

  cluster_name = var.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-ebs-csi-driver"
  })
} 