module ApplicationHelper
  # SEO や SNS シェアに関するメタ情報を管理
  def default_meta_tags
    {
      site: "Resonance-MKT",
      title: "レゾナンスの価格情報管理",
      reverse: true,
      charset: "utf-8",
      description: "Resonance-MKTは、各都市・各商品の価格情報を確認/更新できるアプリです。",
      keywords: "resonance-mkt, レゾナンス, resonance",
      separator: "|",
      canonical: request.original_url,
      og: {
        site_name: "Resonance-MKT",
        title: "レゾナンスの価格情報管理",
        description: "Resonance-MKTは、各都市・各商品の価格情報を確認/更新できるアプリです。",
        type: "website",
        url: request.original_url,
        image: image_url("image_for_og.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@ryunocode",
        image: image_url("image_for_twitter.png")
      }
    }
  end
end
