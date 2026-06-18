<template>
  <div class="page">
    <div class="card" :class="cardClass">
      <div class="update-banner">
        <span class="update-label">Atualizacao aplicada</span>
        <p>Este card foi adicionado para validar o fluxo de atualizacao do frontend no servidor.</p>
      </div>

      <div class="card-header">
        <span class="status-icon">{{ isHealthy ? '✓' : '✗' }}</span>
        <h1>{{ title }}</h1>
      </div>

      <p class="description">{{ description }}</p>

      <div v-if="loading" class="loading">Verificando endpoints...</div>

      <div v-else class="details">
        <div v-if="backendUpdateMessage" class="backend-alert">
          {{ backendUpdateMessage }}
        </div>

        <div class="endpoint" :class="{ ok: basicOk, fail: !basicOk }">
          <strong>GetBasic:</strong> {{ basicMessage }}
        </div>
        <div class="endpoint" :class="{ ok: dataOk, fail: !dataOk }">
          <strong>GetData:</strong> {{ dataMessage }}
        </div>

        <ul v-if="dbItems.length" class="data-list">
          <li v-for="item in dbItems" :key="item.id">
            <span class="item-id">#{{ item.id }}</span> {{ item.message }}
          </li>
        </ul>

        <form class="insert-form" @submit.prevent="submitData">
          <label for="message">Inserir registro (teste de volume)</label>
          <div class="insert-row">
            <input
              id="message"
              v-model="newMessage"
              type="text"
              placeholder="Nova mensagem..."
              :disabled="submitting"
            />
            <button type="submit" :disabled="submitting || !newMessage.trim()">
              {{ submitting ? 'Salvando...' : 'Inserir' }}
            </button>
          </div>
          <p v-if="insertFeedback" class="insert-feedback" :class="insertFeedbackType">
            {{ insertFeedback }}
          </p>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
const API_BASE = import.meta.env.VITE_API_URL || '/api'

export default {
  name: 'App',
  data() {
    return {
      loading: true,
      basicOk: false,
      dataOk: false,
      basicMessage: '',
      dataMessage: '',
      backendUpdateMessage: '',
      dbItems: [],
      newMessage: '',
      submitting: false,
      insertFeedback: '',
      insertFeedbackType: ''
    }
  },
  computed: {
    isHealthy() {
      return this.basicOk && this.dataOk
    },
    cardClass() {
      if (this.loading) return 'card-neutral'
      return this.isHealthy ? 'card-success' : 'card-error'
    },
    title() {
      if (this.loading) return 'Verificando saúde do sistema'
      return this.isHealthy ? 'Sistema saudável' : 'Falha detectada'
    },
    description() {
      if (this.loading) return 'Aguarde enquanto os endpoints são consultados...'
      return this.isHealthy
        ? 'Ambos os endpoints responderam com sucesso e os dados do banco foram carregados.'
        : 'Um ou mais endpoints falharam. Verifique o backend e o PostgreSQL.'
    }
  },
  mounted() {
    this.checkHealth()
  },
  methods: {
    async checkHealth() {
      this.loading = true
      await Promise.all([this.fetchBasic(), this.fetchBackendUpdate(), this.fetchData()])
      this.loading = false
    },
    async fetchBasic() {
      try {
        const response = await fetch(`${API_BASE}/healthy/basic`)
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        const body = await response.json()
        this.basicOk = body.success === true
        this.basicMessage = body.message || 'Resposta recebida'
      } catch (error) {
        this.basicOk = false
        this.basicMessage = `Erro: ${error.message}`
      }
    },
    async fetchBackendUpdate() {
      try {
        const response = await fetch(`${API_BASE}/healthy/backend-update`)
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        const body = await response.json()
        this.backendUpdateMessage = body.message || ''
      } catch {
        this.backendUpdateMessage = ''
      }
    },
    async fetchData() {
      try {
        const response = await fetch(`${API_BASE}/healthy/data`)
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        const body = await response.json()
        this.dataOk = body.success === true && Array.isArray(body.data) && body.data.length > 0
        this.dataMessage = body.message || 'Resposta recebida'
        this.dbItems = body.data || []
      } catch (error) {
        this.dataOk = false
        this.dataMessage = `Erro: ${error.message}`
        this.dbItems = []
      }
    },
    async submitData() {
      const message = this.newMessage.trim()
      if (!message) return

      this.submitting = true
      this.insertFeedback = ''

      try {
        const response = await fetch(`${API_BASE}/healthy/data`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ message })
        })

        const body = await response.json()
        if (!response.ok || body.success !== true) {
          throw new Error(body.message || `HTTP ${response.status}`)
        }

        this.newMessage = ''
        this.insertFeedback = `Registro #${body.data.id} salvo no banco.`
        this.insertFeedbackType = 'ok'
        await this.fetchData()
      } catch (error) {
        this.insertFeedback = `Erro ao inserir: ${error.message}`
        this.insertFeedbackType = 'fail'
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style scoped>
.page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
}

.card {
  width: 100%;
  max-width: 520px;
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
  transition: border-color 0.3s, background 0.3s;
}

.card-neutral {
  background: #1e293b;
  border: 2px solid #475569;
}

.card-success {
  background: linear-gradient(145deg, #14532d, #166534);
  border: 2px solid #22c55e;
}

.card-error {
  background: linear-gradient(145deg, #7f1d1d, #991b1b);
  border: 2px solid #ef4444;
}

.update-banner {
  margin-bottom: 1.25rem;
  padding: 0.9rem 1rem;
  border: 1px solid rgba(250, 204, 21, 0.45);
  border-radius: 12px;
  background: rgba(250, 204, 21, 0.12);
}

.update-label {
  display: block;
  margin-bottom: 0.25rem;
  color: #facc15;
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.update-banner p {
  margin: 0;
  color: #fef3c7;
  font-size: 0.9rem;
  line-height: 1.4;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.status-icon {
  font-size: 1.75rem;
  font-weight: bold;
}

h1 {
  margin: 0;
  font-size: 1.5rem;
  color: #f8fafc;
}

.description {
  color: #e2e8f0;
  margin: 0 0 1.5rem;
  line-height: 1.5;
}

.loading {
  color: #94a3b8;
  font-style: italic;
}

.details {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.endpoint {
  padding: 0.75rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  background: rgba(0, 0, 0, 0.2);
}

.endpoint.ok {
  border-left: 4px solid #22c55e;
}

.endpoint.fail {
  border-left: 4px solid #ef4444;
}

.backend-alert {
  padding: 0.85rem 1rem;
  border: 1px solid rgba(248, 113, 113, 0.65);
  border-radius: 10px;
  background: rgba(127, 29, 29, 0.5);
  color: #fecaca;
  font-weight: 700;
}

.data-list {
  margin: 0.5rem 0 0;
  padding: 0;
  list-style: none;
}

.data-list li {
  padding: 0.5rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  color: #f1f5f9;
  font-size: 0.9rem;
}

.item-id {
  color: #94a3b8;
  margin-right: 0.5rem;
}

.insert-form {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid rgba(255, 255, 255, 0.15);
}

.insert-form label {
  display: block;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
  color: #cbd5e1;
}

.insert-row {
  display: flex;
  gap: 0.5rem;
}

.insert-row input {
  flex: 1;
  padding: 0.6rem 0.75rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  background: rgba(0, 0, 0, 0.25);
  color: #f8fafc;
  font-size: 0.9rem;
}

.insert-row input:focus {
  outline: none;
  border-color: #22c55e;
}

.insert-row button {
  padding: 0.6rem 1rem;
  border: none;
  border-radius: 8px;
  background: #22c55e;
  color: #052e16;
  font-weight: 600;
  cursor: pointer;
}

.insert-row button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.insert-feedback {
  margin: 0.5rem 0 0;
  font-size: 0.85rem;
}

.insert-feedback.ok {
  color: #bbf7d0;
}

.insert-feedback.fail {
  color: #fecaca;
}
</style>
