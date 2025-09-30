# recruitment/middleware.py
class AdminIframeXFrameMiddleware:
    """
    Allows embedding the Django admin under /admin-panel/ inside our /staff/ iframe
    by ensuring SAMEORIGIN on those responses.
    """
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        resp = self.get_response(request)
        if request.path.startswith("/admin-panel/"):
            # Django will already set SAMEORIGIN if X_FRAME_OPTIONS is configured.
            # Re-assert to be safe.
            resp.headers["X-Frame-Options"] = "SAMEORIGIN"
        return resp
