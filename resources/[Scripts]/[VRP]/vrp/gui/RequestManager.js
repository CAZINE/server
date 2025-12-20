function RequestManager(){
	var _this = this;
	setInterval(function(){ _this.tick(); },1000);
	this.requests = []
	this.div = document.createElement("div");
	this.div.classList.add("requestManager");
	document.body.appendChild(this.div);
}

RequestManager.prototype.buildText = function(text,time,id){
	let html = `
	<div class="request ger${id}">
		<header>
			<i class="fas fa-info-circle icon"></i>
			<small>REQUEST</small>
			<div id="accept">Y aceitar</div>
			<div>U recusar</div>
		</header>
		<footer>
			<small>${text}</small>
		</footer>
		<div class="fill random${id}"></div>
	</div>`
	$(html).fadeIn(500).appendTo('.requestManager').delay(formatSeconds(time)).fadeOut(500);
	$(`.random${id}`).css('transition', `width ${formatSeconds(time)}ms`);
	setTimeout(() => {$(`.random${id}`).css('width', '0%');}, 100);
}

RequestManager.prototype.addRequest = function(id,text,time){
	var request = {}
	request.id = id;
	request.time = time-1;
	request.text = text;
	this.requests.push(request);
	this.buildText(text,time-1,id);
}

RequestManager.prototype.respond = function(ok){
	if(this.requests.length > 0){
		var request = this.requests[0];
		if(this.onResponse)
		this.onResponse(request.id,ok);
		$(`.ger${request.id}`).remove()
		this.requests.splice(0,1);
	}
}

RequestManager.prototype.tick = function(){
	for(var i = this.requests.length-1; i >= 0; i--){
		var request = this.requests[i];
		request.time -= 1;
		if(request.time <= 0){
			this.requests.splice(i,1);
		}
	}
}

function formatSeconds(segundos) {
	return segundos.toFixed(3).replace('.', '')
}