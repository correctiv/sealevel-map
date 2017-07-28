<sealevel-article-link>

  <p if={article}>
    <a href={article.url} target="_blank" rel="noopener noreferrer">
      {article.title}
    </a>
  </p>

  <script type="text/babel">
    import articles from 'json!../../config/articles.json'

    this.on('update', () => {
      const language = this.i18n.getLocale()
      this.article = articles[language][this.opts.for]
    })
  </script>

</sealevel-article-link>
