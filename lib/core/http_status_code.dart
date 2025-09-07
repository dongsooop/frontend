enum HttpStatusCode {
  ok(200),
  created(201),
  noContent(204),
  multiStatus(207),
  redirect(302),
  badRequest(400),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  conflict(409),
  internalServerError(500);

  final int code;
  const HttpStatusCode(this.code);
}
