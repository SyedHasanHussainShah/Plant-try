// PlantDoctor App JS

const imageUpload = document.getElementById('imageUpload');
const submitBtn = document.getElementById('submitBtn');
const preview = document.getElementById('preview');
const results = document.getElementById('results');
const plantName = document.getElementById('plantName');
const disease = document.getElementById('disease');
const suggestion = document.getElementById('suggestion');

let selectedFile = null;

// Function to open camera
function openCamera() {
  // Create a temporary file input for camera
  const cameraInput = document.createElement('input');
  cameraInput.type = 'file';
  cameraInput.accept = 'image/*';
  cameraInput.capture = 'environment';
  
  cameraInput.onchange = function(e) {
    const file = e.target.files[0];
    if (file) {
      handleFile(file);
    }
  };
  
  cameraInput.click();
}

function showPreview(file) {
  const reader = new FileReader();
  reader.onload = function (e) {
    preview.innerHTML = `<img src="${e.target.result}" alt="Preview" />`;
  };
  reader.readAsDataURL(file);
}

function handleFile(file) {
  selectedFile = file;
  showPreview(file);
  submitBtn.disabled = false;
  results.classList.remove('show');
  
  // Add success animation
  submitBtn.style.background = 'linear-gradient(135deg, #48bb78 0%, #38a169 100%)';
  setTimeout(() => {
    submitBtn.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
  }, 1000);
}

function handleFileInput(e) {
  const file = e.target.files[0];
  if (file) {
    handleFile(file);
  }
}

imageUpload.addEventListener('change', handleFileInput);

submitBtn.addEventListener('click', async () => {
  if (!selectedFile) return;
  
  submitBtn.disabled = true;
  submitBtn.innerHTML = '<span class="loading"></span> Analyzing...';
  results.classList.remove('show');

  const formData = new FormData();
  formData.append('image', selectedFile);

  try {
    const response = await fetch('/api/analyze', {
      method: 'POST',
      body: formData,
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    
    // Display results with better formatting
    if (data.plant_name) {
      plantName.innerHTML = `<i class="fas fa-seedling"></i> Plant: ${data.plant_name}`;
    } else {
      plantName.innerHTML = `<i class="fas fa-question-circle"></i> Plant: Unknown`;
    }
    
    if (data.disease) {
      disease.innerHTML = `<i class="fas fa-exclamation-triangle"></i> Disease: ${data.disease}`;
    } else {
      disease.innerHTML = `<i class="fas fa-check-circle"></i> No disease detected`;
    }
    
    if (data.suggestion) {
      suggestion.innerHTML = `<i class="fas fa-lightbulb"></i> Care Suggestion: ${data.suggestion}`;
    } else {
      suggestion.innerHTML = `<i class="fas fa-info-circle"></i> No specific care suggestions available`;
    }
    
    results.classList.add('show');
    
    // Add success animation
    submitBtn.style.background = 'linear-gradient(135deg, #48bb78 0%, #38a169 100%)';
    submitBtn.innerHTML = '<i class="fas fa-check"></i> Analysis Complete';
    
    setTimeout(() => {
      submitBtn.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
      submitBtn.innerHTML = '<i class="fas fa-search"></i> <span>Analyze Plant</span>';
    }, 2000);
    
  } catch (err) {
    console.error('Error:', err);
    
    plantName.innerHTML = `<i class="fas fa-exclamation-circle"></i> Plant: Unable to analyze`;
    disease.innerHTML = `<i class="fas fa-times-circle"></i> Error: ${err.message}`;
    suggestion.innerHTML = `<i class="fas fa-info-circle"></i> Please check your connection and try again`;
    
    results.classList.add('show');
    
    // Add error animation
    submitBtn.style.background = 'linear-gradient(135deg, #f56565 0%, #e53e3e 100%)';
    submitBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error';
    
    setTimeout(() => {
      submitBtn.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
      submitBtn.innerHTML = '<i class="fas fa-search"></i> <span>Analyze Plant</span>';
    }, 2000);
    
  } finally {
    submitBtn.disabled = false;
  }
});

// Add some interactive effects
document.addEventListener('DOMContentLoaded', function() {
  // Add hover effects to cards
  const cards = document.querySelectorAll('.upload-card');
  cards.forEach(card => {
    card.addEventListener('mouseenter', function() {
      this.style.transform = 'translateY(-5px) scale(1.02)';
    });
    
    card.addEventListener('mouseleave', function() {
      this.style.transform = 'translateY(0) scale(1)';
    });
  });
});