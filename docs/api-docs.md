---
layout: home
title: PAAPI
description: PAAPI Swagger endpoints and descriptions
---

## Access

The API is intended to be public in the future, but for now please [request a token via email](mailto:bops.register.feedback@unboxed.co).

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
