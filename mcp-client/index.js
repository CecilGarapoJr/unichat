const { CoolifyMCPClient } = require('@wrediam/coolify-mcp-server');
const path = require('path');

// Load configuration
const config = require('../mcp.config.json');

// Initialize the client
const client = new CoolifyMCPClient({
  baseUrl: config.coolify.baseUrl,
  apiKey: config.coolify.apiKey,
  teamId: config.coolify.teamId,
  projectId: config.coolify.projectId
});

// Connect to MCP server
client.connect({
  name: config.name,
  description: config.description,
  version: config.version,
  type: config.type,
  serverUrl: config.server.url,
  token: config.server.token
});

// Export the client for use in scripts
module.exports = client;
