const client = require('../index');

async function deploy() {
  try {
    console.log('Starting deployment...');
    const deployment = await client.deploy({
      repository: process.env.REPOSITORY_URL,
      branch: process.env.BRANCH || 'main',
      environment: process.env.ENVIRONMENT || 'production'
    });
    
    console.log('Deployment started:', deployment.id);
    
    // Monitor deployment status
    const status = await client.waitForDeployment(deployment.id);
    console.log('Deployment status:', status);
  } catch (error) {
    console.error('Deployment failed:', error.message);
    process.exit(1);
  }
}

deploy();
