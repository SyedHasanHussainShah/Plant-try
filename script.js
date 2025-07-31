// PlantDoctor - AI-Powered Plant Care App
class PlantDoctor {
    constructor() {
        this.currentImage = null;
        this.cameraStream = null;
        this.history = JSON.parse(localStorage.getItem('plantDoctorHistory') || '[]');
        this.currentSection = 'scan';
        
        this.init();
    }

    init() {
        // Hide splash screen after 3 seconds
        setTimeout(() => {
            document.getElementById('splash-screen').style.display = 'none';
            document.getElementById('main-app').classList.remove('hidden');
        }, 3000);

        this.setupEventListeners();
        this.loadHistory();
    }

    setupEventListeners() {
        // Navigation
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.navigateToSection(e.target.closest('.nav-btn').dataset.section);
            });
        });

        // Camera and file upload
        document.getElementById('camera-btn').addEventListener('click', () => this.openCamera());
        document.getElementById('gallery-btn').addEventListener('click', () => this.openGallery());
        document.getElementById('file-input').addEventListener('change', (e) => this.handleFileUpload(e));
        
        // Camera controls
        document.getElementById('capture-btn').addEventListener('click', () => this.capturePhoto());
        document.getElementById('close-camera').addEventListener('click', () => this.closeCamera());
        document.getElementById('switch-camera').addEventListener('click', () => this.switchCamera());

        // Results actions
        document.getElementById('back-to-scan').addEventListener('click', () => this.navigateToSection('scan'));
        document.getElementById('save-result').addEventListener('click', () => this.saveToHistory());
        document.getElementById('share-result').addEventListener('click', () => this.shareResult());

        // Drag and drop for file upload
        const uploadArea = document.getElementById('upload-area');
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.style.borderColor = '#22c55e';
        });
        uploadArea.addEventListener('dragleave', () => {
            uploadArea.style.borderColor = '#e2e8f0';
        });
        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.style.borderColor = '#e2e8f0';
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                this.handleFileUpload({ target: { files } });
            }
        });
    }

    navigateToSection(section) {
        // Update navigation buttons
        document.querySelectorAll('.nav-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector(`[data-section="${section}"]`).classList.add('active');

        // Hide all sections
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        
        // Show target section
        document.getElementById(`${section}-section`).classList.add('active');
        
        this.currentSection = section;
    }

    async openCamera() {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ 
                video: { 
                    facingMode: 'environment',
                    width: { ideal: 1920 },
                    height: { ideal: 1080 }
                } 
            });
            this.cameraStream = stream;
            const video = document.getElementById('camera-feed');
            video.srcObject = stream;
            video.onloadedmetadata = () => {
                video.play();
            };
            document.getElementById('camera-interface').classList.remove('hidden');
            document.getElementById('scan-section').classList.add('hidden');
        } catch (error) {
            this.showToast('Camera access denied. Please use gallery upload instead.', 'error');
        }
    }

    closeCamera() {
        if (this.cameraStream) {
            this.cameraStream.getTracks().forEach(track => track.stop());
            this.cameraStream = null;
        }
        
        document.getElementById('camera-interface').classList.add('hidden');
        document.getElementById('scan-section').classList.remove('hidden');
    }

    async switchCamera() {
        if (this.cameraStream) {
            this.cameraStream.getTracks().forEach(track => track.stop());
        }
        
        try {
            const currentFacingMode = this.cameraStream?.getVideoTracks()[0]?.getSettings().facingMode;
            const newFacingMode = currentFacingMode === 'user' ? 'environment' : 'user';
            
            const stream = await navigator.mediaDevices.getUserMedia({ 
                video: { 
                    facingMode: newFacingMode,
                    width: { ideal: 1920 },
                    height: { ideal: 1080 }
                } 
            });
            
            this.cameraStream = stream;
            const video = document.getElementById('camera-feed');
            video.srcObject = stream;
            
        } catch (error) {
            this.showToast('Failed to switch camera', 'error');
        }
    }

    capturePhoto() {
        const video = document.getElementById('camera-feed');
        const canvas = document.getElementById('camera-canvas');
        const context = canvas.getContext('2d');
        if (!video.videoWidth || !video.videoHeight) {
            this.showToast('Camera not ready. Please try again.', 'error');
            return;
        }
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        context.drawImage(video, 0, 0);
        canvas.toBlob((blob) => {
            // Reset analysis steps and progress bar
            this.resetAnalysisUI();
            this.processImage(blob);
        }, 'image/jpeg', 0.8);
        this.closeCamera();
    }

    openGallery() {
        document.getElementById('file-input').click();
    }

    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            this.processImage(file);
        }
    }

    processImage(file) {
        alert('Processing image!'); // DEBUG: Confirm this function is called
        // Create a preview URL
        const reader = new FileReader();
        reader.onload = (e) => {
            this.currentImage = e.target.result;
            // Reset analysis steps and progress bar
            this.resetAnalysisUI();
            this.startAnalysis();
        };
        reader.readAsDataURL(file);
    }

    resetAnalysisUI() {
        // Reset analysis steps
        const steps = document.querySelectorAll('.step');
        steps.forEach((step, idx) => {
            step.classList.remove('active', 'completed');
            if (idx === 0) step.classList.add('active');
        });
        // Reset progress bar
        const progressFill = document.getElementById('progress-fill');
        if (progressFill) progressFill.style.width = '0%';
        const progressText = document.getElementById('progress-text');
        if (progressText) progressText.textContent = 'Processing...';
    }

    startAnalysis() {
        // Show analysis section
        document.getElementById('analysis-section').classList.remove('hidden');
        document.getElementById('upload-area').classList.add('hidden');
        
        // Simulate AI analysis
        this.simulateAnalysis();
    }

    simulateAnalysis() {
        const steps = document.querySelectorAll('.step');
        const progressFill = document.getElementById('progress-fill');
        const progressText = document.getElementById('progress-text');
        
        let currentStep = 0;
        let progress = 0;
        
        const analysisSteps = [
            { text: 'Identifying plant species...', duration: 2000 },
            { text: 'Detecting diseases & pests...', duration: 2500 },
            { text: 'Generating care prescription...', duration: 1500 }
        ];
        
        const interval = setInterval(() => {
            progress += 2;
            progressFill.style.width = `${progress}%`;
            
            if (progress >= 33 && currentStep === 0) {
                steps[0].classList.add('completed');
                steps[1].classList.add('active');
                currentStep = 1;
                progressText.textContent = analysisSteps[1].text;
            } else if (progress >= 66 && currentStep === 1) {
                steps[1].classList.add('completed');
                steps[2].classList.add('active');
                currentStep = 2;
                progressText.textContent = analysisSteps[2].text;
            } else if (progress >= 100) {
                steps[2].classList.add('completed');
                clearInterval(interval);
                setTimeout(() => {
                    this.showResults();
                }, 500);
            }
        }, 50);
    }

    showResults() {
        // Hide analysis section
        document.getElementById('analysis-section').classList.add('hidden');
        // Show upload area for next scan
        document.getElementById('upload-area').classList.remove('hidden');
        // Generate mock results
        const results = this.generateMockResults();
        // Update results UI
        document.getElementById('result-image').src = this.currentImage;
        document.getElementById('plant-name').textContent = results.plantName;
        document.getElementById('plant-scientific').textContent = results.scientificName;
        document.getElementById('confidence-score').textContent = `${results.confidence}%`;
        // Update diagnosis
        const diagnosisContent = document.getElementById('diagnosis-content');
        diagnosisContent.innerHTML = results.diagnosis.map(item => `
            <div class="diagnosis-item">
                <h4><i class="fas ${item.icon}"></i> ${item.title}</h4>
                <p>${item.description}</p>
            </div>
        `).join('');
        // Update prescription
        const prescriptionContent = document.getElementById('prescription-content');
        prescriptionContent.innerHTML = results.prescription.map(item => `
            <div class="prescription-item">
                <h4><i class="fas ${item.icon}"></i> ${item.title}</h4>
                <p>${item.description}</p>
            </div>
        `).join('');
        // Always show results section
        this.navigateToSection('results');
    }

    generateMockResults() {
        const plants = [
            { name: 'Rose (Rosa)', scientific: 'Rosa sp.', confidence: 95 },
            { name: 'Monstera Deliciosa', scientific: 'Monstera deliciosa', confidence: 92 },
            { name: 'Snake Plant', scientific: 'Sansevieria trifasciata', confidence: 88 },
            { name: 'Peace Lily', scientific: 'Spathiphyllum sp.', confidence: 90 },
            { name: 'Pothos', scientific: 'Epipremnum aureum', confidence: 87 }
        ];
        const diseases = [
            { title: 'Leaf Spot Disease', icon: 'fa-bug', description: 'Small brown spots on leaves indicating fungal infection.' },
            { title: 'Powdery Mildew', icon: 'fa-snowflake', description: 'White powdery substance on leaves and stems.' },
            { title: 'Root Rot', icon: 'fa-water', description: 'Yellowing leaves and mushy roots due to overwatering.' },
            { title: 'Spider Mites', icon: 'fa-spider', description: 'Tiny pests causing yellow spots and webbing.' }
        ];
        const treatments = [
            { title: 'Remove Affected Leaves', icon: 'fa-cut', description: 'Carefully remove and dispose of infected leaves to prevent spread.' },
            { title: 'Apply Neem Oil', icon: 'fa-tint', description: 'Spray neem oil solution weekly to treat fungal and pest issues.' },
            { title: 'Improve Air Circulation', icon: 'fa-wind', description: 'Ensure proper spacing and ventilation to prevent disease.' },
            { title: 'Adjust Watering', icon: 'fa-tint', description: 'Water only when soil is dry to prevent root rot.' }
        ];
        const randomPlant = plants[Math.floor(Math.random() * plants.length)];
        // Always at least one disease and two treatments
        const diseaseCount = Math.floor(Math.random() * 2) + 1;
        const treatmentCount = Math.floor(Math.random() * 2) + 2;
        const shuffledDiseases = diseases.sort(() => 0.5 - Math.random());
        const shuffledTreatments = treatments.sort(() => 0.5 - Math.random());
        const randomDiseases = shuffledDiseases.slice(0, diseaseCount);
        const randomTreatments = shuffledTreatments.slice(0, treatmentCount);
        return {
            plantName: randomPlant.name,
            scientificName: randomPlant.scientific,
            confidence: randomPlant.confidence,
            diagnosis: randomDiseases,
            prescription: randomTreatments
        };
    }

    saveToHistory() {
        const result = {
            id: Date.now(),
            image: this.currentImage,
            plantName: document.getElementById('plant-name').textContent,
            scientificName: document.getElementById('plant-scientific').textContent,
            confidence: document.getElementById('confidence-score').textContent,
            date: new Date().toISOString(),
            diagnosis: Array.from(document.querySelectorAll('.diagnosis-item')).map(item => ({
                title: item.querySelector('h4').textContent.replace(/.*?fa-\w+\s*/, ''),
                description: item.querySelector('p').textContent
            })),
            prescription: Array.from(document.querySelectorAll('.prescription-item')).map(item => ({
                title: item.querySelector('h4').textContent.replace(/.*?fa-\w+\s*/, ''),
                description: item.querySelector('p').textContent
            }))
        };
        
        this.history.unshift(result);
        localStorage.setItem('plantDoctorHistory', JSON.stringify(this.history));
        
        this.showToast('Result saved to history!', 'success');
    }

    loadHistory() {
        const historyList = document.getElementById('history-list');
        
        if (this.history.length === 0) {
            historyList.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-history" style="font-size: 3rem; color: #94a3b8; margin-bottom: 1rem;"></i>
                    <h3>No scans yet</h3>
                    <p>Your plant analysis history will appear here</p>
                </div>
            `;
            return;
        }
        
        historyList.innerHTML = this.history.map(item => `
            <div class="history-item" onclick="plantDoctor.viewHistoryItem(${item.id})">
                <img src="${item.image}" alt="${item.plantName}" class="history-image">
                <div class="history-details">
                    <h4>${item.plantName}</h4>
                    <p>${item.scientificName}</p>
                    <div class="history-date">${new Date(item.date).toLocaleDateString()}</div>
                </div>
                <div class="history-confidence">${item.confidence}</div>
            </div>
        `).join('');
    }

    viewHistoryItem(id) {
        const item = this.history.find(h => h.id === id);
        if (!item) return;
        
        // Update results with history data
        this.currentImage = item.image;
        document.getElementById('result-image').src = item.image;
        document.getElementById('plant-name').textContent = item.plantName;
        document.getElementById('plant-scientific').textContent = item.scientificName;
        document.getElementById('confidence-score').textContent = item.confidence;
        
        // Update diagnosis
        const diagnosisContent = document.getElementById('diagnosis-content');
        diagnosisContent.innerHTML = item.diagnosis.map(d => `
            <div class="diagnosis-item">
                <h4><i class="fas fa-bug"></i> ${d.title}</h4>
                <p>${d.description}</p>
            </div>
        `).join('');
        
        // Update prescription
        const prescriptionContent = document.getElementById('prescription-content');
        prescriptionContent.innerHTML = item.prescription.map(p => `
            <div class="prescription-item">
                <h4><i class="fas fa-stethoscope"></i> ${p.title}</h4>
                <p>${p.description}</p>
            </div>
        `).join('');
        
        this.navigateToSection('results');
    }

    shareResult() {
        if (navigator.share) {
            navigator.share({
                title: 'PlantDoctor Analysis',
                text: `I analyzed my plant with PlantDoctor! Found: ${document.getElementById('plant-name').textContent}`,
                url: window.location.href
            });
        } else {
            // Fallback: copy to clipboard
            const text = `PlantDoctor Analysis: ${document.getElementById('plant-name').textContent}`;
            navigator.clipboard.writeText(text).then(() => {
                this.showToast('Analysis copied to clipboard!', 'success');
            });
        }
    }

    showToast(message, type = 'success') {
        const toast = document.getElementById('toast');
        const toastMessage = toast.querySelector('.toast-message');
        const toastIcon = toast.querySelector('.toast-icon');
        
        toastMessage.textContent = message;
        toast.className = `toast ${type}`;
        toastIcon.className = `toast-icon fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}`;
        
        toast.classList.remove('hidden');
        toast.classList.add('show');
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => {
                toast.classList.add('hidden');
            }, 300);
        }, 3000);
    }
}

// Initialize the app
const plantDoctor = new PlantDoctor();

// Add some sample data for demonstration
if (plantDoctor.history.length === 0) {
    const sampleData = [
        {
            id: Date.now() - 86400000,
            image: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIiBmaWxsPSIjRjNGNEY2Ii8+CjxwYXRoIGQ9Ik0xMDAgNTBDMTEwLjQ1NyA1MCAxMTkgNTguNTQzNSAxMTkgNjlDMTE5IDc5LjQ1NjUgMTEwLjQ1NyA4OCAxMDAgODhDODkuNTQzNSA4OCA4MSA3OS40NTY1IDgxIDY5QzgxIDU4LjU0MzUgODkuNTQzNSA1MCAxMDAgNTBaIiBmaWxsPSIjMjJDMjVFIi8+CjxwYXRoIGQ9Ik05MCAxMjBDOTAgMTEwIDk1IDEwMCAxMDAgMTAwQzEwNSAxMDAgMTEwIDExMCAxMTAgMTIwQzExMCAxMzAgMTA1IDE0MCAxMDAgMTQwQzk1IDE0MCA5MCAxMzAgOTAgMTIwWiIgZmlsbD0iIzIyQzI1RSIvPgo8L3N2Zz4K',
            plantName: 'Rose (Rosa)',
            scientificName: 'Rosa sp.',
            confidence: '95%',
            date: new Date(Date.now() - 86400000).toISOString(),
            diagnosis: [
                { title: 'Black Spot Disease', description: 'Dark spots on leaves indicating fungal infection.' }
            ],
            prescription: [
                { title: 'Remove Affected Leaves', description: 'Carefully remove and dispose of infected leaves.' },
                { title: 'Apply Fungicide', description: 'Spray with copper-based fungicide weekly.' }
            ]
        }
    ];
    
    plantDoctor.history = sampleData;
    localStorage.setItem('plantDoctorHistory', JSON.stringify(sampleData));
    plantDoctor.loadHistory();
}