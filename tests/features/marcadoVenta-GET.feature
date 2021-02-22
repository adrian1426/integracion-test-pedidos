Feature: /pedidos GET

  Consulta del pedido.

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

  Scenario: /pedidos Consulta del pedido correctamente 200 ok.

    Given I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter | value    |
      | idPedido  | 103265   |
      | idOrden   | V2312303 |

    When I GET `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 200
    And response body should be valid json

    And response body path $.codigo should be ([A-Za-z])+.\w+
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.pedido[*].tipoVenta should be ^([0-9])*$
    And response body path $.resultado.pedido[*].tipoMarcado should be ^([0-9])*$
    And response body path $.resultado.pedido[*].estatus should be ^([0-9])*$
    And response body path $.resultado.pedido[*].fecha should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.pedido[*].totalPedido should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.pedido[*].clienteUnico.idNegocio should be ^([0-9])*$
    And response body path $.resultado.pedido[*].clienteUnico.sucursal should be ^([0-9])*$
    And response body path $.resultado.pedido[*].clienteUnico.idCliente should be ^([0-9])*$
    And response body path $.resultado.pedido[*].clienteUnico.digitoVerificador should be ^([0-9])*$
    And response body path $.resultado.pedido[*].informacionCliente[*].apellidoMaterno should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].apellidoPaterno should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].correoElectronico should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].nombre should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.tipoDireccion should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.nombreDestinatario should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.idDireccion should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.codigoPostal should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.ciudad should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.estado should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.pais should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.calle should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.numero should be ^([0-9])*$
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.delegacion should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.complemento should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.pedido[*].informacionCliente[*].direccion.referencia should be ([A-Za-z])+.\w+
    And response body path $.resultado.pedido[*].tipoMilenia should be ^([0-9])*$
    And response body path $.resultado.pedido[*].telefonia should be ^(?:tru|fals)e$
    And response body path $.resultado.pedido[*].motos should be ^(?:tru|fals)e$
    And response body path $.resultado.pedido[*].seguros should be ^(?:tru|fals)e$
    And response body path $.resultado.pedido[*].motoNuevasMarcas should be ^(?:tru|fals)e$
    And response body path $.resultado.pedido[*].ventaEmpleado should be ^(?:tru|fals)e$
    And response body path $.resultado.detallePedido[*].cantidad should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].clase should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].departamento should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].descripcion should be ([A-Za-z])+.\w+
    And response body path $.resultado.detallePedido[*].esInventariable should be ^(?:tru|fals)e$
    And response body path $.resultado.detallePedido[*].estatusProducto should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].existenciaProducto should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].precio should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].precioChaz should be ^([0-9])*$
    And response body path $.resultado.detallePedido[*].requiereSerie should be ^(?:tru|fals)e$
    And response body path $.resultado.detallePedido[*].serie should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].estacionTrabajo should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].idUsuario should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].idProveedor should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].cantidad should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].costoProducto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].descuento should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].milenias[*].sku should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].milenias[*].sobrePrecio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].promociones[*].cantidad should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].promociones[*].idPromocion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].promociones[*].idRegalo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].promociones[*].monto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].promociones[*].subTipoPromocion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].promociones[*].tipoPromocion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].mecanica should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].precio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].sku should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].sobrePrecio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionVenta[*].descuentoEspecial should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].referenciaEktCom should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].tipoVenta should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].totalVenta should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.tipoPago should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.plazoMsi should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.idBanco should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.numeroTarjeta should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.referenciaPago should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.monto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.canal should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionPago.numeroPagos should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].consecutivoPedido should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].costoEstimado should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idTipoEntrega should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].proveedorEnvio should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].idOmnicanal should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].totalPedidos should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].afectaContabilidad should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idMercado should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].montoVentaMP should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].montoComision should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idPenalizacion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].montoPenalizacion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idOrigenEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].pedidoOtorgaRegalo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].skuOtorgaRegalo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].evitarSuministro should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].idNegocio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idPaqueteria should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idTiendaSurte should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].idProveedor should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].dsv should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraComTienda[*].ordenDistribucion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].notaCargo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].numeroFactura should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].idOrden should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].fechaSuministro should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].urlRastreo should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].idCodigoSurtimiento should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].gastosAdicionales[*].monto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].gastosAdicionales[*].idGasto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].guia should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].paqueteria should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].idPedidoAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraComTienda[*].informacionNotaDebito.idNotaDebito should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionNotaDebito.personaQueRecibe should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraComTienda[*].informacionNotaDebito.numeroRastreo should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraComTienda[*].informacionNotaDebito.idAlmacen should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.idUnico should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.secuencia should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.secuenciaOriginal should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.referencia should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.idPais should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.idOrigenSolicitud should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.correoSocio should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.idTipoPago should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.idTipoVenta should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.idEstatusOrden should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.idTipoEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.totalPago should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.totalCostoEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.totalDescuento should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.fechaRegistro should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.idTipoEntrega should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.fechaUltimoCambio should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.totalImpuestos should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.idAlmacen should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.idVendedor should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.tipoTransaccion should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.totalPedidos should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.esReemplazo should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.esMercado should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.referencia should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.numeroSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.numeroPedido should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.consecutivo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.identificadorExcepcion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.descripcionExcepcion should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.estadoDomicilio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.identificadorProducto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.excepcionEntrega.fechaRegistro should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.identificadorUnico should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.identificadorProducto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.precioVenta should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.descuento should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.costo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.comision should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.montoImpuestos should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.descuentoEspecial should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.cantidad should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.precioEspecial should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.categoria should be [^\n]+
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.precioLista should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.numeroPortador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.nombrePortador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.numeroSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.numeroPedido should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.tipoEnvio should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.consecutivo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.idTipoEntrega should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleVentaOrden.metodoPago should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleComprador.folioComprador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleComprador.correoElectronico should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleComprador.nombre should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleComprador.apellidos should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleComprador.numeroTelefono should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleComprador.socioCorporativo should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.detalleComprador.identificadorUnico should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.estadoDSVItalika should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.folioEnvio should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.nombre should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.direccion should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.colonia should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.estado should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.numeroEstado should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.datosEnvio.codigoPostal should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.datosEnvio.ciudad should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.ciudadPrincipal should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.pais should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.numeroTelefono should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.datosEnvio.referencia should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.personaAutoriza should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.datosEnvio.numeroInterno should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.numeroExterno should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.tipoDireccion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.datosEnvio.identificadorUnico should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.numeroPortador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.datosEnvio.nombrePortador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].numeroPortador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].nombrePortador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].identificadorUnico should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].numeroSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].tipoOperacionAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].estadoOrden should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].folioComprador should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].numeroTienda should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].numeroPedido should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].numeroCliente should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.solicitudAdn[*].digitoVerificador should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idUnico should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].costoEnvio.idSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].costoEnvio.idPedidoAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].costoEnvio.idProducto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].costoEnvio.montoEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].totales.idSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].totales.totalPedido should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].totales.descuento should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].consecutivo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].esServicio should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].subcategoria should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idSubcategoria should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].skuProveedor should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idAlmacen should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idPaqueteriaEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].servicioPaqueteriaEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idVendedor should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].fechaPromesa should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].fechaCalle should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].adnEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].comisionCalculada should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].porcentajeComision should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].montoOriginal should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].montoCredito should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idTipoVendedorMercado should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idProductoOriginal should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].costo should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].conjunto should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].ordenAdnInclusivo should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].tipoPromocionSap should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].esDSVMultiproveedor should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].tieneGuia should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idPedidoAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].idProducto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].promocionCve should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].tipoPromocion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].subTipoPromocion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].cantidad should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].cupon should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].monto should be ^[0-9]+([.][0-9]+)?$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].productoRegresado should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].regalo should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.detalleSolicitudAdn[*].numeroTienda should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.idTransaccion should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.referenciaVtex should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.idPago should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.idOrdenElektra should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.idTipoTransaccion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.totalTransaccion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.cargasCostosEnvio should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.valorImpuestos should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.direccionIP should be [^\n]+
    And response body path $.resultado.ordenElektraCom.transaccionesPago.pagoAprobado should be ^(?:tru|fals)e$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.codigoAutenticacion should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.folioBanco should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.idTipoPago should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.marcaTarjetaCredito should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.digitosTarjetaCredito should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.tarjetaCredito should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.mesesSinIntereses should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.codigoRechazo should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.descripcionRechazo should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.fechaPago should be [^\n]+
    And response body path $.resultado.ordenElektraCom.transaccionesPago.fechaDevolucion should be [^\n]+
    And response body path $.resultado.ordenElektraCom.transaccionesPago.fechaRegistro should be [^\n]+
    And response body path $.resultado.ordenElektraCom.transaccionesPago.urlLlamadaDevuelta should be [^\n]+
    And response body path $.resultado.ordenElektraCom.transaccionesPago.nombreSistemaPago should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.transaccionesPago.promocionesMSI.liquidaciones should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.promocionesMSI.idBanco should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.transaccionesPago.promocionesMSI.concecionesBancarias should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.dimensiones.idUnico should be ^[A-z-0-9]{0,}$
    And response body path $.resultado.ordenElektraCom.dimensiones.idSolicitudAdn should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.dimensiones.pesoCubico should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.dimensiones.altitud should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.dimensiones.longitud should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.dimensiones.amplitud should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.paypalMercadoPago.monto should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.paypalMercadoPago.correoElectronico should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.paypalMercadoPago.idSolicitud should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.paypalMercadoPago.estado should be ^([0-9])*$
    And response body path $.resultado.ordenElektraCom.detallesAccertify[*].tipoImporte should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detallesAccertify[*].codigoRecomendacion should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detallesAccertify[*].codigoResolucion should be ([A-Za-z])+.\w+
    And response body path $.resultado.ordenElektraCom.detallesAccertify[*].fechaRegistro should be ([A-Za-z])+.\w+


  Scenario: /pedidos 400 bad request.

    Given I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter | value    |
      | idPedido  | null     |
      | idOrden   | V2312303 |

    When I GET `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 400
    And response body should be valid json

    And response body path $.codigo should be ^400\.Elektra-comercio-Pedidos\.\d{4}$
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#400\.Elektra-comercio-Pedidos\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ([A-Za-z])+.\w+


  Scenario: /pedidos 404 not found.

    Given I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter | value    |
      | idPedido  | 111111   |
      | idOrden   | V2312303 |

    When I GET `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 404
    And response body should be valid json

    And response body path $.codigo should be ^404\.Elektra-comercio-Pedidos\.\d{4}$
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#404\.Elektra-comercio-Pedidos\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ([A-Za-z])+.\w+


  Scenario: /pedidos 500 internal server error.

    Given I set bearer token
    And I have valid client TLS configuration

    And I set headers to
      | name           | value |
      | x-pais         | 1     |
      | x-canal        | 1     |
      | x-numeroTienda | 100   |

    And I set query parameters to
      | parameter | value |
      | idPedido  | null  |
      | idOrden   | null  |

    When I GET `apigeeDomain`/elektra/comercio/`deploymentSuffix`/pedidos

    Then response code should be 500
    And response body should be valid json

    And response body path $.codigo should be ^500\.Elektra-comercio-Pedidos\.\d{4}$
    And response body path $.mensaje should be ([A-Za-z])+.\w+
    And response body path $.folio should be ^[A-z-0-9]{0,}$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#500\.Elektra-comercio-Pedidos\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ([A-Za-z])+.\w+
