const client = require('../index');

async function getLogs() {
  try {
    console.log('Fetching deployment logs...');
    const logs = await client.getLogs();
    console.log('Deployment logs:', logs);
  } catch (error) {
    console.error('Failed to get logs:', error.message);
    process.exit(1);
  }
}

getLogs();
