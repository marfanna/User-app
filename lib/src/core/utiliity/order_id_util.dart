String maskOrderId(String id) {
  if (id.length <= 4) return id;
  return '...${id.substring(id.length - 4)}';
}
