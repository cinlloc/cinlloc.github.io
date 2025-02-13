# How to setup an Ollama instance in Vast.ai and use it?
## Vast.ai
* Create an account
* Provide $50 credit or credit card payment information
* Select OpenWebUI (+ollama) template, instanciate
* Select an instance with H100 80GB VRAM GPU (be careful on network performances, since correct models are ~40GB)
* Start it, wait for ready, push your ssh public key on it
## Locally
* Open an ssh tunnel to redirect OpenWebUI and Ollama ports (cf. doc https://cloud.vast.ai/template/readme/5d2c8df8e0d0ab7d1a7a3ed0f9105637#ssh-port-forwarding)
* Example: `ssh root@ssh5.vast.ai -p 16777 -L 7500:localhost:17500 -L 11434:localhost:21434`
* Download a model from your terminal instance: `ollama pull mistral`
* Now you can use chat via web ui or connect your IDE plugin (CodeGPT aka ProxyAI) to https://localhost:11434
