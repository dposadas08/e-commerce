class Direccion {
  constructor({ id, usuario_id, direccion, ciudad, provincia, codigo_postal, pais, estado }) {
    this.id = id || null;
    this.usuario_id = usuario_id || null;
    this.direccion = direccion || '';
    this.ciudad = ciudad || '';
    this.provincia = provincia || '';
    this.codigo_postal = codigo_postal || '';
    this.pais = pais || '';
    this.estado = estado || 'A';
  }
}