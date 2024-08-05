resource "aws_eks_addon" "adot" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "adot"
  addon_version     = "v0.94.1-eksbuild.1"
  service_account_role_arn = aws_iam_role.adot_role.arn
  depends_on = [helm_release.cert-manager]
}

data "aws_iam_policy_document" "aws_adot" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "adot_role" {
  name               = "${aws_eks_cluster.eks.name}-aws-adot"
  assume_role_policy = data.aws_iam_policy_document.aws_adot.json
}

resource "aws_iam_role_policy_attachment" "adot_role_policy_cni" {
  role       = aws_iam_role.adot_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "adot_role_policy_prom" {
  role       = aws_iam_role.adot_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
}
resource "aws_iam_role_policy_attachment" "adot_role_policy_xray" {
  role       = aws_iam_role.adot_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "adot_role_policy_cw" {
  role       = aws_iam_role.adot_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}