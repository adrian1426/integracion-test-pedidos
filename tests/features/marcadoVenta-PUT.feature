Feature: /pedidos PUT - Actualizar orden o pedido

  Realiza el Marcado de la Venta

  Scenario: Negocio un consumer key y secret key de la app de prueba

    Given I have basic authentication credentials `apigeeUsername` and `apigeePassword`
    And I have valid client TLS configuration

    When I GET `apigeeHost`/v1/organizations/`apigeeOrg`/developers/`apigeeDeveloper`/apps/`apigeeApp`

    Then response code should be 200
    And response body should be valid json
    And I store the value of body path $.credentials[0].consumerKey as globalConsumerKey in global scope
    And I store the value of body path $.credentials[0].consumerSecret as globalConsumerSecret in global scope

  Scenario: Negocia un access token con el Authorization server

    Given I set form parameters to
      | parameter  | value              |
      | grant_type | client_credentials |

    And I have basic authentication credentials `globalConsumerKey` and `globalConsumerSecret`
    And I have valid client TLS configuration

    When I POST to `apigeeDomain`/`apigeeOauthEndpoint`

    Then response code should be 200
    And response body should be valid json
    And I store the value of body path $.access_token as access token

  Scenario: /pedidos 201 Se actualiza la orden o pedido.

    Given I set Content-Type header to application/json
    And I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter    | value |
      | idPedido     | 0     |
      | idOrden      | 0     |
      | estadoPedido | 0     |


    And I set body to {"folio": 863167, "numeroEmpleado": 146363, "referencia": "VentaServicioWeb", "referenciaCaja": [{"importe": 8771, "tipoPago": 1, "referencia": 1}], "folioOrden": "V2312303", "informacionEcomercio": {"detalleOrden": {"estacionTrabajo": "GERENTE", "idUsuario": "T146363", "informacionVenta": [{"idProveedor": "v-25", "cantidad": 1, "costoProducto": 100, "descuento": 0, "listaMilenias": [{"sku": 1002522, "sobrePrecio": 5}], "promociones": [{"cantidad": 1, "idPromocion": 5555, "idRegalo": 12, "monto": 5, "subTipoPromocion": 20, "tipoPromocion": 10}], "mecanica": 0, "precio": 112, "sku": 1002520, "sobrePrecio": 0, "descuentoEspecial": 0}], "referenciaEktCom": "v26864600ekt-V", "tipoVenta": 1, "totalVenta": 31999, "informacionPago": {"tipoPago": 2, "plazoMsi": 12, "idBanco": 14, "numeroTarjeta": "C4772143013277427", "referenciaPago": 124520, "monto": 110, "canal": 1, "numeroPagos": 12}, "consecutivoPedido": 1, "costoEstimado": 0, "tipoEntrega": 1, "proveedorEnvio": "MarketplaceGenerico", "omnicanalId": 3, "totalPedidos": 2, "afectaContabilidad": 0, "idMercado": 1, "montoVentaMP": 0, "montoComision": 0, "idPenalizacion": 0, "montoPenalizacion": 0, "idOrigenEnvio": 22, "pedidoOtorgaRegalo": 0, "skuOtorgaRegalo": 1002510, "evitarSuministro": null, "idNegocio": 12, "idPaqueteria": 22, "tiendaSurte": 4624, "proveedor": 999999, "dsv": false, "ordenDistribucion": 292907, "notaCargo": 4860246, "numeroFactura": null, "idOrden": null, "fechaSuministro": "2021-01-07T09:00:00", "urlRastreo": "https://www.dhl.com/mx-es/home/rastreo.html", "idCodigoSurtimiento": 139, "gastosAdicionales": [{"monto": 0, "idGasto": 1}], "guia": "EKT000000000041502", "paqueteria": "ektnvia", "pedidoADNTdaOrigen": 0, "informacionNotaDebito": [{"idNotaDebito": 775049, "personaQueRecibe": "Miguel Ruiz", "numeroRastreo": "000000000588270", "idAlmacen": 139}]}, "informacionCliente": {"apellidoMaterno": "Castellanos", "apellidoPaterno": "Montesinos", "correoElectronico": "cmontesinos@mail.com", "nombre": "Paola", "direccion": {"tipoDireccion": "residential", "nombreDestinatario": "Claudia Pérez", "idDireccion": "38c8395027e140909bd23fcdcdf831ba", "codigoPostal": "09704", "ciudad": "Iztapalapa", "estado": "DISTRITO FEDERAL", "pais": "MEX", "calle": "José Clemente Orozco", "numero": 48, "delegacion": "Degollado", "complemento": 2, "referencia": null}}}}
    When I PUT `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 201
    And response body should be valid json
    And response body path $.codigo should be ([A-Za-z])+.\w+
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.pedidoValido should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenValido should be ^(?:tru|fals)e$

  Scenario: /pedidos 400 bad request.

    Given I set Content-Type header to application/json
    And I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter    | value |
      | idPedido     | 0     |
      | idOrden      | 0     |
      | estadoPedido | 0     |

    And I set body to {"folio": null, "numeroEmpleado": 146363, "referencia": "VentaServicioWeb", "referenciaCaja": [{"importe": 8771, "tipoPago": 1, "referencia": 1}], "folioOrden": "V2312303", "informacionEcomercio": {"detalleOrden": {"estacionTrabajo": "GERENTE", "idUsuario": "T146363", "informacionVenta": [{"idProveedor": "v-25", "cantidad": 1, "costoProducto": 100, "descuento": 0, "listaMilenias": [{"sku": 1002522, "sobrePrecio": 5}], "promociones": [{"cantidad": 1, "idPromocion": 5555, "idRegalo": 12, "monto": 5, "subTipoPromocion": 20, "tipoPromocion": 10}], "mecanica": 0, "precio": 112, "sku": 1002520, "sobrePrecio": 0, "descuentoEspecial": 0}], "referenciaEktCom": "v26864600ekt-V", "tipoVenta": 1, "totalVenta": 31999, "informacionPago": {"tipoPago": 2, "plazoMsi": 12, "idBanco": 14, "numeroTarjeta": "C4772143013277427", "referenciaPago": 124520, "monto": 110, "canal": 1, "numeroPagos": 12}, "consecutivoPedido": 1, "costoEstimado": 0, "tipoEntrega": 1, "proveedorEnvio": "MarketplaceGenerico", "omnicanalId": 3, "totalPedidos": 2, "afectaContabilidad": 0, "idMercado": 1, "montoVentaMP": 0, "montoComision": 0, "idPenalizacion": 0, "montoPenalizacion": 0, "idOrigenEnvio": 22, "pedidoOtorgaRegalo": 0, "skuOtorgaRegalo": 1002510, "evitarSuministro": null, "idNegocio": 12, "idPaqueteria": 22, "tiendaSurte": 4624, "proveedor": 999999, "dsv": false, "ordenDistribucion": 292907, "notaCargo": 4860246, "numeroFactura": null, "idOrden": null, "fechaSuministro": "2021-01-07T09:00:00", "urlRastreo": "https://www.dhl.com/mx-es/home/rastreo.html", "idCodigoSurtimiento": 139, "gastosAdicionales": [{"monto": 0, "idGasto": 1}], "guia": "EKT000000000041502", "paqueteria": "ektnvia", "pedidoADNTdaOrigen": 0, "informacionNotaDebito": [{"idNotaDebito": 775049, "personaQueRecibe": "Miguel Ruiz", "numeroRastreo": "000000000588270", "idAlmacen": 139}]}, "informacionCliente": {"apellidoMaterno": "Castellanos", "apellidoPaterno": "Montesinos", "correoElectronico": "cmontesinos@mail.com", "nombre": "Paola", "direccion": {"tipoDireccion": "residential", "nombreDestinatario": "Claudia Pérez", "idDireccion": "38c8395027e140909bd23fcdcdf831ba", "codigoPostal": "09704", "ciudad": "Iztapalapa", "estado": "DISTRITO FEDERAL", "pais": "MEX", "calle": "José Clemente Orozco", "numero": 48, "delegacion": "Degollado", "complemento": 2, "referencia": null}}}}
    When I PUT `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 400
    And response body should be valid json
    And response body path $.respuesta.codigo should be ([A-Za-z])+.\w+
    And response body path $.respuesta.mensaje should be ([A-Za-z])+.\w+
    And response body path $.respuesta.folio should be ^[A-z-0-9]{0,}$
    And response body path $.respuesta.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#400\.Elektra-comercio-Pedidos\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.respuesta.detalles[*] should be ([A-Za-z])+.\w+

  Scenario: /pedidos 404 internal server error.

    Given I set Content-Type header to application/json
    And I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter    | value |
      | idPedido     | 0     |
      | idOrden      | 0     |
      | estadoPedido | 0     |

    And I set body to {"folio": 111111, "numeroEmpleado": 146363, "referencia": "VentaServicioWeb", "referenciaCaja": [{"importe": 8771, "tipoPago": 1, "referencia": 1}], "folioOrden": "V2312303", "informacionEcomercio": {"detalleOrden": {"estacionTrabajo": "GERENTE", "idUsuario": "T146363", "informacionVenta": [{"idProveedor": "v-25", "cantidad": 1, "costoProducto": 100, "descuento": 0, "listaMilenias": [{"sku": 1002522, "sobrePrecio": 5}], "promociones": [{"cantidad": 1, "idPromocion": 5555, "idRegalo": 12, "monto": 5, "subTipoPromocion": 20, "tipoPromocion": 10}], "mecanica": 0, "precio": 112, "sku": 1002520, "sobrePrecio": 0, "descuentoEspecial": 0}], "referenciaEktCom": "v26864600ekt-V", "tipoVenta": 1, "totalVenta": 31999, "informacionPago": {"tipoPago": 2, "plazoMsi": 12, "idBanco": 14, "numeroTarjeta": "C4772143013277427", "referenciaPago": 124520, "monto": 110, "canal": 1, "numeroPagos": 12}, "consecutivoPedido": 1, "costoEstimado": 0, "tipoEntrega": 1, "proveedorEnvio": "MarketplaceGenerico", "omnicanalId": 3, "totalPedidos": 2, "afectaContabilidad": 0, "idMercado": 1, "montoVentaMP": 0, "montoComision": 0, "idPenalizacion": 0, "montoPenalizacion": 0, "idOrigenEnvio": 22, "pedidoOtorgaRegalo": 0, "skuOtorgaRegalo": 1002510, "evitarSuministro": null, "idNegocio": 12, "idPaqueteria": 22, "tiendaSurte": 4624, "proveedor": 999999, "dsv": false, "ordenDistribucion": 292907, "notaCargo": 4860246, "numeroFactura": null, "idOrden": null, "fechaSuministro": "2021-01-07T09:00:00", "urlRastreo": "https://www.dhl.com/mx-es/home/rastreo.html", "idCodigoSurtimiento": 139, "gastosAdicionales": [{"monto": 0, "idGasto": 1}], "guia": "EKT000000000041502", "paqueteria": "ektnvia", "pedidoADNTdaOrigen": 0, "informacionNotaDebito": [{"idNotaDebito": 775049, "personaQueRecibe": "Miguel Ruiz", "numeroRastreo": "000000000588270", "idAlmacen": 139}]}, "informacionCliente": {"apellidoMaterno": "Castellanos", "apellidoPaterno": "Montesinos", "correoElectronico": "cmontesinos@mail.com", "nombre": "Paola", "direccion": {"tipoDireccion": "residential", "nombreDestinatario": "Claudia Pérez", "idDireccion": "38c8395027e140909bd23fcdcdf831ba", "codigoPostal": "09704", "ciudad": "Iztapalapa", "estado": "DISTRITO FEDERAL", "pais": "MEX", "calle": "José Clemente Orozco", "numero": 48, "delegacion": "Degollado", "complemento": 2, "referencia": null}}}}
    When I PUT `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 404
    And response body should be valid json
    And response body path $.codigo should be ([A-Za-z])+.\w+
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#404\.Elektra-comercio-Pedidos\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ([A-Za-z])+.\w+

  Scenario: /pedidos 500 internal server error.

    Given I set Content-Type header to application/json
    And I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter    | value |
      | idPedido     | 0     |
      | idOrden      | 0     |
      | estadoPedido | 0     |

    And I set body to {"folio": null, "numeroEmpleado": null, "referencia": "VentaServicioWeb", "referenciaCaja": [{"importe": 8771, "tipoPago": 1, "referencia": 1}], "folioOrden": "V2312303", "informacionEcomercio": {"detalleOrden": {"estacionTrabajo": "GERENTE", "idUsuario": "T146363", "informacionVenta": [{"idProveedor": "v-25", "cantidad": 1, "costoProducto": 100, "descuento": 0, "listaMilenias": [{"sku": 1002522, "sobrePrecio": 5}], "promociones": [{"cantidad": 1, "idPromocion": 5555, "idRegalo": 12, "monto": 5, "subTipoPromocion": 20, "tipoPromocion": 10}], "mecanica": 0, "precio": 112, "sku": 1002520, "sobrePrecio": 0, "descuentoEspecial": 0}], "referenciaEktCom": "v26864600ekt-V", "tipoVenta": 1, "totalVenta": 31999, "informacionPago": {"tipoPago": 2, "plazoMsi": 12, "idBanco": 14, "numeroTarjeta": "C4772143013277427", "referenciaPago": 124520, "monto": 110, "canal": 1, "numeroPagos": 12}, "consecutivoPedido": 1, "costoEstimado": 0, "tipoEntrega": 1, "proveedorEnvio": "MarketplaceGenerico", "omnicanalId": 3, "totalPedidos": 2, "afectaContabilidad": 0, "idMercado": 1, "montoVentaMP": 0, "montoComision": 0, "idPenalizacion": 0, "montoPenalizacion": 0, "idOrigenEnvio": 22, "pedidoOtorgaRegalo": 0, "skuOtorgaRegalo": 1002510, "evitarSuministro": null, "idNegocio": 12, "idPaqueteria": 22, "tiendaSurte": 4624, "proveedor": 999999, "dsv": false, "ordenDistribucion": 292907, "notaCargo": 4860246, "numeroFactura": null, "idOrden": null, "fechaSuministro": "2021-01-07T09:00:00", "urlRastreo": "https://www.dhl.com/mx-es/home/rastreo.html", "idCodigoSurtimiento": 139, "gastosAdicionales": [{"monto": 0, "idGasto": 1}], "guia": "EKT000000000041502", "paqueteria": "ektnvia", "pedidoADNTdaOrigen": 0, "informacionNotaDebito": [{"idNotaDebito": 775049, "personaQueRecibe": "Miguel Ruiz", "numeroRastreo": "000000000588270", "idAlmacen": 139}]}, "informacionCliente": {"apellidoMaterno": "Castellanos", "apellidoPaterno": "Montesinos", "correoElectronico": "cmontesinos@mail.com", "nombre": "Paola", "direccion": {"tipoDireccion": "residential", "nombreDestinatario": "Claudia Pérez", "idDireccion": "38c8395027e140909bd23fcdcdf831ba", "codigoPostal": "09704", "ciudad": "Iztapalapa", "estado": "DISTRITO FEDERAL", "pais": "MEX", "calle": "José Clemente Orozco", "numero": 48, "delegacion": "Degollado", "complemento": 2, "referencia": null}}}}
    When I PUT `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 500
    And response body should be valid json
    And response body path $.codigo should be ([A-Za-z])+.\w+
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#500\.Elektra-comercio-Pedidos\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ([A-Za-z])+.\w+