class ApiConfig {
  static const String baseUrl = 'http://localhost:8081/api';
  static const String aiServiceUrl = 'http://localhost:5000';
  
  // Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String userRequests = '$baseUrl/user/requests';
  static const String createRequest = '$baseUrl/user/requests';
  static const String agentPendingRequests = '$baseUrl/agent/pending-requests';
  static const String agentRequests = '$baseUrl/agent/requests';
  static const String validateRequest = '$baseUrl/agent/requests';
  static const String adminUsers = '$baseUrl/admin/users';
  static const String adminStats = '$baseUrl/admin/stats';
  static const String adminRequests = '$baseUrl/admin/requests';
}

