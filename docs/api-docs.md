---
layout: home
title: PAAPI
description: paapi description
---
<link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css" />
<div id="swagger-ui"></div>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>
<script>
  window.onload = () => {
    window.ui = SwaggerUIBundle({
      url: '../swagger_doc.yaml',
      dom_id: '#swagger-ui'
    });
  }
</script>
