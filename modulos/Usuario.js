class Usuario {
  constructor({ id, nombre, apellido, dni, email, password, rol, fecha_registro, estado }) {
    this.id = id || null;
    this.nombre = nombre || '';
    this.apellido = apellido || '';
    this.dni = dni || null;
    this.email = email || '';
    this.password = password || '';
    this.rol = rol || '';
    this.fecha_registro = fecha_registro || new Date();
    this.estado = estado || 'A'; // Asumí 'A' para activo como default
  }
}