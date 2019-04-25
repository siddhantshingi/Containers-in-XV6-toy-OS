
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 ca 10 80       	mov    $0x8010ca70,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb b4 ca 10 80       	mov    $0x8010cab4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 80 10 80       	push   $0x801080a0
80100051:	68 80 ca 10 80       	push   $0x8010ca80
80100056:	e8 b5 4f 00 00       	call   80105010 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 cc 11 11 80 7c 	movl   $0x8011117c,0x801111cc
80100062:	11 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 d0 11 11 80 7c 	movl   $0x8011117c,0x801111d0
8010006c:	11 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 7c 11 11 80       	mov    $0x8011117c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 7c 11 11 80 	movl   $0x8011117c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 80 10 80       	push   $0x801080a7
80100097:	50                   	push   %eax
80100098:	e8 43 4e 00 00       	call   80104ee0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 d0 11 11 80       	mov    0x801111d0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d d0 11 11 80    	mov    %ebx,0x801111d0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 7c 11 11 80       	cmp    $0x8011117c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 80 ca 10 80       	push   $0x8010ca80
801000e4:	e8 67 50 00 00       	call   80105150 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d d0 11 11 80    	mov    0x801111d0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 7c 11 11 80    	cmp    $0x8011117c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 7c 11 11 80    	cmp    $0x8011117c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d cc 11 11 80    	mov    0x801111cc,%ebx
80100126:	81 fb 7c 11 11 80    	cmp    $0x8011117c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 7c 11 11 80    	cmp    $0x8011117c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 80 ca 10 80       	push   $0x8010ca80
80100162:	e8 a9 50 00 00       	call   80105210 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 4d 00 00       	call   80104f20 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 80 10 80       	push   $0x801080ae
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 0d 4e 00 00       	call   80104fc0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 80 10 80       	push   $0x801080bf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 cc 4d 00 00       	call   80104fc0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 4d 00 00       	call   80104f80 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 80 ca 10 80 	movl   $0x8010ca80,(%esp)
8010020b:	e8 40 4f 00 00       	call   80105150 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 d0 11 11 80       	mov    0x801111d0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 7c 11 11 80 	movl   $0x8011117c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 d0 11 11 80       	mov    0x801111d0,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d d0 11 11 80    	mov    %ebx,0x801111d0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 80 ca 10 80 	movl   $0x8010ca80,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 4f 00 00       	jmp    80105210 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 80 10 80       	push   $0x801080c6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b9 10 80 	movl   $0x8010b920,(%esp)
8010028c:	e8 bf 4e 00 00       	call   80105150 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 60 14 11 80    	mov    0x80111460,%edx
801002a7:	39 15 64 14 11 80    	cmp    %edx,0x80111464
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b9 10 80       	push   $0x8010b920
801002c0:	68 60 14 11 80       	push   $0x80111460
801002c5:	e8 16 3c 00 00       	call   80103ee0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 60 14 11 80    	mov    0x80111460,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 64 14 11 80    	cmp    0x80111464,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 60 36 00 00       	call   80103940 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b9 10 80       	push   $0x8010b920
801002ef:	e8 1c 4f 00 00       	call   80105210 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 60 14 11 80       	mov    %eax,0x80111460
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 e0 13 11 80 	movsbl -0x7feeec20(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b9 10 80       	push   $0x8010b920
8010034d:	e8 be 4e 00 00       	call   80105210 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 60 14 11 80    	mov    %edx,0x80111460
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b9 10 80 00 	movl   $0x0,0x8010b954
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 80 10 80       	push   $0x801080cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 07 87 10 80 	movl   $0x80108707,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 4c 00 00       	call   80105030 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 80 10 80       	push   $0x801080e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b9 10 80 01 	movl   $0x1,0x8010b958
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b9 10 80    	mov    0x8010b958,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 61 68 00 00       	call   80106ca0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 af 67 00 00       	call   80106ca0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 a3 67 00 00       	call   80106ca0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 97 67 00 00       	call   80106ca0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 e7 4d 00 00       	call   80105310 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 1a 4d 00 00       	call   80105260 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 80 10 80       	push   $0x801080e5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 10 81 10 80 	movzbl -0x7fef7ef0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b9 10 80 	movl   $0x8010b920,(%esp)
8010061b:	e8 30 4b 00 00       	call   80105150 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b9 10 80       	push   $0x8010b920
80100647:	e8 c4 4b 00 00       	call   80105210 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b9 10 80       	mov    0x8010b954,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b9 10 80       	push   $0x8010b920
8010071f:	e8 ec 4a 00 00       	call   80105210 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba f8 80 10 80       	mov    $0x801080f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b9 10 80       	push   $0x8010b920
801007f0:	e8 5b 49 00 00       	call   80105150 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 80 10 80       	push   $0x801080ff
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b9 10 80       	push   $0x8010b920
80100823:	e8 28 49 00 00       	call   80105150 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 68 14 11 80       	mov    0x80111468,%eax
80100856:	3b 05 64 14 11 80    	cmp    0x80111464,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 68 14 11 80       	mov    %eax,0x80111468
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b9 10 80       	push   $0x8010b920
80100888:	e8 83 49 00 00       	call   80105210 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 68 14 11 80       	mov    0x80111468,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 60 14 11 80    	sub    0x80111460,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 68 14 11 80    	mov    %edx,0x80111468
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 e0 13 11 80    	mov    %cl,-0x7feeec20(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 60 14 11 80       	mov    0x80111460,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 68 14 11 80    	cmp    %eax,0x80111468
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 64 14 11 80       	mov    %eax,0x80111464
          wakeup(&input.r);
80100911:	68 60 14 11 80       	push   $0x80111460
80100916:	e8 85 37 00 00       	call   801040a0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 68 14 11 80       	mov    0x80111468,%eax
8010093d:	39 05 64 14 11 80    	cmp    %eax,0x80111464
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 68 14 11 80       	mov    %eax,0x80111468
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 68 14 11 80       	mov    0x80111468,%eax
80100964:	3b 05 64 14 11 80    	cmp    0x80111464,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba e0 13 11 80 0a 	cmpb   $0xa,-0x7feeec20(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 e4 37 00 00       	jmp    80104180 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 e0 13 11 80 0a 	movb   $0xa,-0x7feeec20(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 68 14 11 80       	mov    0x80111468,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 08 81 10 80       	push   $0x80108108
801009cb:	68 20 b9 10 80       	push   $0x8010b920
801009d0:	e8 3b 46 00 00       	call   80105010 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 2c 1e 11 80 00 	movl   $0x80100600,0x80111e2c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 28 1e 11 80 70 	movl   $0x80100270,0x80111e28
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b9 10 80 01 	movl   $0x1,0x8010b954
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 1f 2f 00 00       	call   80103940 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 84 21 00 00       	call   80102bb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 ac 21 00 00       	call   80102c20 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 57 73 00 00       	call   80107df0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 15 71 00 00       	call   80107c10 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 23 70 00 00       	call   80107b50 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 f9 71 00 00       	call   80107d70 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 61 70 00 00       	call   80107c10 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 aa 71 00 00       	call   80107d70 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 81 10 80       	push   $0x80108121
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 85 72 00 00       	call   80107e90 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 42 48 00 00       	call   80105480 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 2f 48 00 00       	call   80105480 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 8e 73 00 00       	call   80107ff0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 24 73 00 00       	call   80107ff0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 31 47 00 00       	call   80105440 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 87 6c 00 00       	call   801079c0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 2f 70 00 00       	call   80107d70 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 2d 81 10 80       	push   $0x8010812d
80100d6b:	68 80 14 11 80       	push   $0x80111480
80100d70:	e8 9b 42 00 00       	call   80105010 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb b4 14 11 80       	mov    $0x801114b4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 80 14 11 80       	push   $0x80111480
80100d91:	e8 ba 43 00 00       	call   80105150 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 14 1e 11 80    	cmp    $0x80111e14,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 80 14 11 80       	push   $0x80111480
80100dc1:	e8 4a 44 00 00       	call   80105210 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 80 14 11 80       	push   $0x80111480
80100dda:	e8 31 44 00 00       	call   80105210 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 80 14 11 80       	push   $0x80111480
80100dff:	e8 4c 43 00 00       	call   80105150 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 80 14 11 80       	push   $0x80111480
80100e1c:	e8 ef 43 00 00       	call   80105210 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 81 10 80       	push   $0x80108134
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 80 14 11 80       	push   $0x80111480
80100e51:	e8 fa 42 00 00       	call   80105150 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 80 14 11 80 	movl   $0x80111480,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 8f 43 00 00       	jmp    80105210 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 80 14 11 80       	push   $0x80111480
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 63 43 00 00       	call   80105210 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 8a 24 00 00       	call   80103360 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 cb 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 21 1d 00 00       	jmp    80102c20 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 81 10 80       	push   $0x8010813c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 3e 25 00 00       	jmp    80103510 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 81 10 80       	push   $0x80108146
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 d2 1b 00 00       	call   80102c20 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 35 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 6e 1b 00 00       	call   80102c20 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 0e 23 00 00       	jmp    80103400 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 81 10 80       	push   $0x8010814f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 81 10 80       	push   $0x80108155
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d 80 1e 11 80    	mov    0x80111e80,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 98 1e 11 80    	add    0x80111e98,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 80 1e 11 80       	mov    0x80111e80,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 80 1e 11 80    	cmp    %eax,0x80111e80
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 5f 81 10 80       	push   $0x8010815f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ae 1b 00 00       	call   80102d80 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 66 40 00 00       	call   80105260 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 7e 1b 00 00       	call   80102d80 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb d4 1e 11 80       	mov    $0x80111ed4,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 a0 1e 11 80       	push   $0x80111ea0
8010123a:	e8 11 3f 00 00       	call   80105150 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb f4 3a 11 80    	cmp    $0x80113af4,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb f4 3a 11 80    	cmp    $0x80113af4,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 a0 1e 11 80       	push   $0x80111ea0
8010129f:	e8 6c 3f 00 00       	call   80105210 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 a0 1e 11 80       	push   $0x80111ea0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 3e 3f 00 00       	call   80105210 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 75 81 10 80       	push   $0x80108175
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 1d 1a 00 00       	call   80102d80 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 85 81 10 80       	push   $0x80108185
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 1a 3f 00 00       	call   80105310 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 80 1e 11 80       	push   $0x80111e80
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 98 1e 11 80    	add    0x80111e98,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 11 19 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 98 81 10 80       	push   $0x80108198
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb e0 1e 11 80       	mov    $0x80111ee0,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 ab 81 10 80       	push   $0x801081ab
801014a1:	68 a0 1e 11 80       	push   $0x80111ea0
801014a6:	e8 65 3b 00 00       	call   80105010 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 b2 81 10 80       	push   $0x801081b2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 1c 3a 00 00       	call   80104ee0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 00 3b 11 80    	cmp    $0x80113b00,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 80 1e 11 80       	push   $0x80111e80
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 98 1e 11 80    	pushl  0x80111e98
801014e5:	ff 35 94 1e 11 80    	pushl  0x80111e94
801014eb:	ff 35 90 1e 11 80    	pushl  0x80111e90
801014f1:	ff 35 8c 1e 11 80    	pushl  0x80111e8c
801014f7:	ff 35 88 1e 11 80    	pushl  0x80111e88
801014fd:	ff 35 84 1e 11 80    	pushl  0x80111e84
80101503:	ff 35 80 1e 11 80    	pushl  0x80111e80
80101509:	68 18 82 10 80       	push   $0x80108218
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d 88 1e 11 80 01 	cmpl   $0x1,0x80111e88
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d 88 1e 11 80    	cmp    %ebx,0x80111e88
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 94 1e 11 80    	add    0x80111e94,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 bd 3c 00 00       	call   80105260 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 cb 17 00 00       	call   80102d80 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 b8 81 10 80       	push   $0x801081b8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 94 1e 11 80    	add    0x80111e94,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 ca 3c 00 00       	call   80105310 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 32 17 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 a0 1e 11 80       	push   $0x80111ea0
8010166f:	e8 dc 3a 00 00       	call   80105150 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
8010167f:	e8 8c 3b 00 00       	call   80105210 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 69 38 00 00       	call   80104f20 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 94 1e 11 80    	add    0x80111e94,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 e3 3b 00 00       	call   80105310 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 d0 81 10 80       	push   $0x801081d0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ca 81 10 80       	push   $0x801081ca
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 38 38 00 00       	call   80104fc0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 dc 37 00 00       	jmp    80104f80 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 df 81 10 80       	push   $0x801081df
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 4b 37 00 00       	call   80104f20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 91 37 00 00       	call   80104f80 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
801017f6:	e8 55 39 00 00       	call   80105150 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 a0 1e 11 80 	movl   $0x80111ea0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 fb 39 00 00       	jmp    80105210 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 a0 1e 11 80       	push   $0x80111ea0
80101820:	e8 2b 39 00 00       	call   80105150 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
8010182f:	e8 dc 39 00 00       	call   80105210 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 f4 38 00 00       	call   80105310 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 20 1e 11 80 	mov    -0x7feee1e0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 f8 37 00 00       	call   80105310 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 60 12 00 00       	call   80102d80 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 24 1e 11 80 	mov    -0x7feee1dc(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 cd 37 00 00       	call   80105380 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 6e 37 00 00       	call   80105380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 f9 81 10 80       	push   $0x801081f9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 e7 81 10 80       	push   $0x801081e7
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 b2 1c 00 00       	call   80103940 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 a0 1e 11 80       	push   $0x80111ea0
80101c99:	e8 b2 34 00 00       	call   80105150 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
80101ca9:	e8 62 35 00 00       	call   80105210 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 06 36 00 00       	call   80105310 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 73 35 00 00       	call   80105310 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 4e 35 00 00       	call   801053e0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 08 82 10 80       	push   $0x80108208
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 7e 89 10 80       	push   $0x8010897e
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 74 82 10 80       	push   $0x80108274
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 6b 82 10 80       	push   $0x8010826b
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 86 82 10 80       	push   $0x80108286
8010201b:	68 80 b9 10 80       	push   $0x8010b980
80102020:	e8 eb 2f 00 00       	call   80105010 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 c0 41 11 80       	mov    0x801141c0,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 b9 10 80 01 	movl   $0x1,0x8010b960
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 b9 10 80       	push   $0x8010b980
8010209e:	e8 ad 30 00 00       	call   80105150 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 b9 10 80    	mov    0x8010b964,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 b9 10 80       	mov    %eax,0x8010b964

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 9a 1f 00 00       	call   801040a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 b9 10 80       	mov    0x8010b964,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 b9 10 80       	push   $0x8010b980
8010211f:	e8 ec 30 00 00       	call   80105210 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 7d 2e 00 00       	call   80104fc0 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 b9 10 80       	mov    0x8010b960,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 b9 10 80       	push   $0x8010b980
80102178:	e8 d3 2f 00 00       	call   80105150 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 b9 10 80    	mov    0x8010b964,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 b9 10 80    	cmp    %ebx,0x8010b964
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 b9 10 80       	push   $0x8010b980
801021c8:	53                   	push   %ebx
801021c9:	e8 12 1d 00 00       	call   80103ee0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 b9 10 80 	movl   $0x8010b980,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 25 30 00 00       	jmp    80105210 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 b9 10 80       	mov    $0x8010b964,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 a0 82 10 80       	push   $0x801082a0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 8a 82 10 80       	push   $0x8010828a
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 b5 82 10 80       	push   $0x801082b5
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 f4 3a 11 80 00 	movl   $0xfec00000,0x80113af4
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 f4 3a 11 80       	mov    0x80113af4,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d f4 3a 11 80    	mov    0x80113af4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 20 3c 11 80 	movzbl 0x80113c20,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 d4 82 10 80       	push   $0x801082d4
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d f4 3a 11 80    	mov    0x80113af4,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d f4 3a 11 80    	mov    0x80113af4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d f4 3a 11 80    	mov    0x80113af4,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d f4 3a 11 80    	mov    0x80113af4,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d f4 3a 11 80    	mov    0x80113af4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 f4 3a 11 80       	mov    0x80113af4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb e8 39 13 80    	cmp    $0x801339e8,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 09 2f 00 00       	call   80105260 <memset>

  if(kmem.use_lock)
80102357:	8b 15 34 3b 11 80    	mov    0x80113b34,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102364:	a1 38 3b 11 80       	mov    0x80113b38,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010236b:	a1 34 3b 11 80       	mov    0x80113b34,%eax
  kmem.freelist = r;
80102370:	89 1d 38 3b 11 80    	mov    %ebx,0x80113b38
  if(kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 00 3b 11 80 	movl   $0x80113b00,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 80 2e 00 00       	jmp    80105210 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 00 3b 11 80       	push   $0x80113b00
80102398:	e8 b3 2d 00 00       	call   80105150 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 06 83 10 80       	push   $0x80108306
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 0c 83 10 80       	push   $0x8010830c
80102410:	68 00 3b 11 80       	push   $0x80113b00
80102415:	e8 f6 2b 00 00       	call   80105010 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 34 3b 11 80 00 	movl   $0x0,0x80113b34
80102427:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 34 3b 11 80 01 	movl   $0x1,0x80113b34
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024d0:	a1 34 3b 11 80       	mov    0x80113b34,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 38 3b 11 80       	mov    0x80113b38,%eax
  if(r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 38 3b 11 80    	mov    %edx,0x80113b38
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 00 3b 11 80       	push   $0x80113b00
80102503:	e8 48 2c 00 00       	call   80105150 <acquire>
  r = kmem.freelist;
80102508:	a1 38 3b 11 80       	mov    0x80113b38,%eax
  if(r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 34 3b 11 80    	mov    0x80113b34,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 38 3b 11 80    	mov    %ecx,0x80113b38
  if(kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 00 3b 11 80       	push   $0x80113b00
80102531:	e8 da 2c 00 00       	call   80105210 <release>
  return (char*)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 c2 00 00 00    	je     80102610 <kbdgetc+0xd0>
8010254e:	ba 60 00 00 00       	mov    $0x60,%edx
80102553:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102554:	0f b6 d0             	movzbl %al,%edx
80102557:	8b 0d b4 b9 10 80    	mov    0x8010b9b4,%ecx

  if(data == 0xE0){
8010255d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102563:	0f 84 7f 00 00 00    	je     801025e8 <kbdgetc+0xa8>
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	53                   	push   %ebx
8010256d:	89 cb                	mov    %ecx,%ebx
8010256f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102572:	84 c0                	test   %al,%al
80102574:	78 4a                	js     801025c0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 09                	je     80102583 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010257d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102580:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102583:	0f b6 82 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010258c:	0f b6 82 40 83 10 80 	movzbl -0x7fef7cc0(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102597:	89 0d b4 b9 10 80    	mov    %ecx,0x8010b9b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025a0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 20 83 10 80 	mov    -0x7fef7ce0(,%eax,4),%eax
801025aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ae:	74 31                	je     801025e1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b3:	83 fa 19             	cmp    $0x19,%edx
801025b6:	77 40                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025bb:	5b                   	pop    %ebx
801025bc:	5d                   	pop    %ebp
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025c0:	83 e0 7f             	and    $0x7f,%eax
801025c3:	85 db                	test   %ebx,%ebx
801025c5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025c8:	0f b6 82 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
    return 0;
801025d9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 b9 10 80    	mov    %ecx,0x8010b9b4
}
801025e1:	5b                   	pop    %ebx
801025e2:	5d                   	pop    %ebp
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025e8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025eb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025ed:	89 0d b4 b9 10 80    	mov    %ecx,0x8010b9b4
    return 0;
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025fe:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102602:	0f 42 c2             	cmovb  %edx,%eax
}
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102626:	68 40 25 10 80       	push   $0x80102540
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
}
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102640:	a1 3c 3b 11 80       	mov    0x80113b3c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
  lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
  lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
  lapic[index] = value;
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102715:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102740:	8b 15 3c 3b 11 80    	mov    0x80113b3c,%edx
{
80102746:	55                   	push   %ebp
80102747:	31 c0                	xor    %eax,%eax
80102749:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102760:	a1 3c 3b 11 80       	mov    0x80113b3c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	b8 0f 00 00 00       	mov    $0xf,%eax
80102796:	ba 70 00 00 00       	mov    $0x70,%edx
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	ba 71 00 00 00       	mov    $0x71,%edx
801027af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027c0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027c3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ce:	a1 3c 3b 11 80       	mov    0x80113b3c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	b8 0b 00 00 00       	mov    $0xb,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102842:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102845:	8d 76 00             	lea    0x0(%esi),%esi
80102848:	31 c0                	xor    %eax,%eax
8010284a:	89 da                	mov    %ebx,%edx
8010284c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	b8 02 00 00 00       	mov    $0x2,%eax
8010285f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
80102863:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102866:	89 da                	mov    %ebx,%edx
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
80102871:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102874:	89 da                	mov    %ebx,%edx
80102876:	b8 07 00 00 00       	mov    $0x7,%eax
8010287b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 da                	mov    %ebx,%edx
80102884:	b8 08 00 00 00       	mov    $0x8,%eax
80102889:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	b8 09 00 00 00       	mov    $0x9,%eax
80102896:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102897:	89 ca                	mov    %ecx,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289c:	89 da                	mov    %ebx,%edx
8010289e:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	89 ca                	mov    %ecx,%edx
801028a6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a7:	84 c0                	test   %al,%al
801028a9:	78 9d                	js     80102848 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028af:	89 fa                	mov    %edi,%edx
801028b1:	0f b6 fa             	movzbl %dl,%edi
801028b4:	89 f2                	mov    %esi,%edx
801028b6:	0f b6 f2             	movzbl %dl,%esi
801028b9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028c4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028cb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d9:	31 c0                	xor    %eax,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
801028f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 da                	mov    %ebx,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
80102912:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 da                	mov    %ebx,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
80102934:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	50                   	push   %eax
80102943:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102946:	50                   	push   %eax
80102947:	e8 64 29 00 00       	call   801052b0 <memcmp>
8010294c:	83 c4 10             	add    $0x10,%esp
8010294f:	85 c0                	test   %eax,%eax
80102951:	0f 85 f1 fe ff ff    	jne    80102848 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102957:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010295b:	75 78                	jne    801029d5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102960:	89 c2                	mov    %eax,%edx
80102962:	83 e0 0f             	and    $0xf,%eax
80102965:	c1 ea 04             	shr    $0x4,%edx
80102968:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102971:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102974:	89 c2                	mov    %eax,%edx
80102976:	83 e0 0f             	and    $0xf,%eax
80102979:	c1 ea 04             	shr    $0x4,%edx
8010297c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102982:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102985:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102988:	89 c2                	mov    %eax,%edx
8010298a:	83 e0 0f             	and    $0xf,%eax
8010298d:	c1 ea 04             	shr    $0x4,%edx
80102990:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102993:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102996:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299c:	89 c2                	mov    %eax,%edx
8010299e:	83 e0 0f             	and    $0xf,%eax
801029a1:	c1 ea 04             	shr    $0x4,%edx
801029a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d5:	8b 75 08             	mov    0x8(%ebp),%esi
801029d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029db:	89 06                	mov    %eax,(%esi)
801029dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e0:	89 46 04             	mov    %eax,0x4(%esi)
801029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e6:	89 46 08             	mov    %eax,0x8(%esi)
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 46 0c             	mov    %eax,0xc(%esi)
801029ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f2:	89 46 10             	mov    %eax,0x10(%esi)
801029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a05:	5b                   	pop    %ebx
80102a06:	5e                   	pop    %esi
80102a07:	5f                   	pop    %edi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d 88 3b 11 80    	mov    0x80113b88,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 8a 00 00 00    	jle    80102aa8 <install_trans+0x98>
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	31 db                	xor    %ebx,%ebx
{
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 74 3b 11 80       	mov    0x80113b74,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 84 3b 11 80    	pushl  0x80113b84
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d 8c 3b 11 80 	pushl  -0x7feec474(,%ebx,4)
80102a54:	ff 35 84 3b 11 80    	pushl  0x80113b84
  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 97 28 00 00       	call   80105310 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d 88 3b 11 80    	cmp    %ebx,0x80113b88
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa8:	f3 c3                	repz ret 
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	ff 35 74 3b 11 80    	pushl  0x80113b74
80102abe:	ff 35 84 3b 11 80    	pushl  0x80113b84
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac9:	8b 1d 88 3b 11 80    	mov    0x80113b88,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ad2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ad6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	7e 16                	jle    80102af1 <write_head+0x41>
80102adb:	c1 e3 02             	shl    $0x2,%ebx
80102ade:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ae0:	8b 8a 8c 3b 11 80    	mov    -0x7feec474(%edx),%ecx
80102ae6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102aea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <write_head+0x30>
  }
  bwrite(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	56                   	push   %esi
80102af5:	e8 a6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102afa:	89 34 24             	mov    %esi,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>
}
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b08:	5b                   	pop    %ebx
80102b09:	5e                   	pop    %esi
80102b0a:	5d                   	pop    %ebp
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b1a:	68 40 85 10 80       	push   $0x80108540
80102b1f:	68 40 3b 11 80       	push   $0x80113b40
80102b24:	e8 e7 24 00 00       	call   80105010 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 9b e8 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  log.dev = dev;
80102b3c:	89 1d 84 3b 11 80    	mov    %ebx,0x80113b84
  log.size = sb.nlog;
80102b42:	89 15 78 3b 11 80    	mov    %edx,0x80113b78
  log.start = sb.logstart;
80102b48:	a3 74 3b 11 80       	mov    %eax,0x80113b74
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b55:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b5d:	89 1d 88 3b 11 80    	mov    %ebx,0x80113b88
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a 88 3b 11 80    	mov    %ecx,-0x7feec478(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 88 3b 11 80 00 	movl   $0x0,0x80113b88
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
}
80102b9e:	83 c4 10             	add    $0x10,%esp
80102ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 40 3b 11 80       	push   $0x80113b40
80102bbb:	e8 90 25 00 00       	call   80105150 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 40 3b 11 80       	push   $0x80113b40
80102bd0:	68 40 3b 11 80       	push   $0x80113b40
80102bd5:	e8 06 13 00 00       	call   80103ee0 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bdd:	a1 80 3b 11 80       	mov    0x80113b80,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 7c 3b 11 80       	mov    0x80113b7c,%eax
80102beb:	8b 15 88 3b 11 80    	mov    0x80113b88,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c02:	a3 7c 3b 11 80       	mov    %eax,0x80113b7c
      release(&log.lock);
80102c07:	68 40 3b 11 80       	push   $0x80113b40
80102c0c:	e8 ff 25 00 00       	call   80105210 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 40 3b 11 80       	push   $0x80113b40
80102c2e:	e8 1d 25 00 00       	call   80105150 <acquire>
  log.outstanding -= 1;
80102c33:	a1 7c 3b 11 80       	mov    0x80113b7c,%eax
  if(log.committing)
80102c38:	8b 35 80 3b 11 80    	mov    0x80113b80,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c44:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c46:	89 1d 7c 3b 11 80    	mov    %ebx,0x80113b7c
  if(log.committing)
80102c4c:	0f 85 1a 01 00 00    	jne    80102d6c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c52:	85 db                	test   %ebx,%ebx
80102c54:	0f 85 ee 00 00 00    	jne    80102d48 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c5a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c5d:	c7 05 80 3b 11 80 01 	movl   $0x1,0x80113b80
80102c64:	00 00 00 
  release(&log.lock);
80102c67:	68 40 3b 11 80       	push   $0x80113b40
80102c6c:	e8 9f 25 00 00       	call   80105210 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c71:	8b 0d 88 3b 11 80    	mov    0x80113b88,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c82:	a1 74 3b 11 80       	mov    0x80113b74,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 84 3b 11 80    	pushl  0x80113b84
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d 8c 3b 11 80 	pushl  -0x7feec474(,%ebx,4)
80102ca6:	ff 35 84 3b 11 80    	pushl  0x80113b84
  for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102caf:	e8 1c d4 ff ff       	call   801000d0 <bread>
80102cb4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb9:	83 c4 0c             	add    $0xc,%esp
80102cbc:	68 00 02 00 00       	push   $0x200
80102cc1:	50                   	push   %eax
80102cc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc5:	50                   	push   %eax
80102cc6:	e8 45 26 00 00       	call   80105310 <memmove>
    bwrite(to);  // write the log
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 cd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd3:	89 3c 24             	mov    %edi,(%esp)
80102cd6:	e8 05 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 fd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce3:	83 c4 10             	add    $0x10,%esp
80102ce6:	3b 1d 88 3b 11 80    	cmp    0x80113b88,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cf8:	c7 05 88 3b 11 80 00 	movl   $0x0,0x80113b88
80102cff:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
    acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 40 3b 11 80       	push   $0x80113b40
80102d0f:	e8 3c 24 00 00       	call   80105150 <acquire>
    wakeup(&log);
80102d14:	c7 04 24 40 3b 11 80 	movl   $0x80113b40,(%esp)
    log.committing = 0;
80102d1b:	c7 05 80 3b 11 80 00 	movl   $0x0,0x80113b80
80102d22:	00 00 00 
    wakeup(&log);
80102d25:	e8 76 13 00 00       	call   801040a0 <wakeup>
    release(&log.lock);
80102d2a:	c7 04 24 40 3b 11 80 	movl   $0x80113b40,(%esp)
80102d31:	e8 da 24 00 00       	call   80105210 <release>
80102d36:	83 c4 10             	add    $0x10,%esp
}
80102d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3c:	5b                   	pop    %ebx
80102d3d:	5e                   	pop    %esi
80102d3e:	5f                   	pop    %edi
80102d3f:	5d                   	pop    %ebp
80102d40:	c3                   	ret    
80102d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 40 3b 11 80       	push   $0x80113b40
80102d50:	e8 4b 13 00 00       	call   801040a0 <wakeup>
  release(&log.lock);
80102d55:	c7 04 24 40 3b 11 80 	movl   $0x80113b40,(%esp)
80102d5c:	e8 af 24 00 00       	call   80105210 <release>
80102d61:	83 c4 10             	add    $0x10,%esp
}
80102d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d67:	5b                   	pop    %ebx
80102d68:	5e                   	pop    %esi
80102d69:	5f                   	pop    %edi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
    panic("log.committing");
80102d6c:	83 ec 0c             	sub    $0xc,%esp
80102d6f:	68 44 85 10 80       	push   $0x80108544
80102d74:	e8 17 d6 ff ff       	call   80100390 <panic>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d87:	8b 15 88 3b 11 80    	mov    0x80113b88,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 78 3b 11 80       	mov    0x80113b78,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102da9:	a1 7c 3b 11 80       	mov    0x80113b7c,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 40 3b 11 80       	push   $0x80113b40
80102dbe:	e8 8d 23 00 00       	call   80105150 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d 88 3b 11 80    	mov    0x80113b88,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd6:	3b 15 8c 3b 11 80    	cmp    0x80113b8c,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 8c 3b 11 80 	cmp    %edx,-0x7feec474(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102df0:	89 14 85 8c 3b 11 80 	mov    %edx,-0x7feec474(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 88 3b 11 80       	mov    %eax,0x80113b88
  b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e02:	c7 45 08 40 3b 11 80 	movl   $0x80113b40,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
  release(&log.lock);
80102e0d:	e9 fe 23 00 00       	jmp    80105210 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e18:	89 14 85 8c 3b 11 80 	mov    %edx,-0x7feec474(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 8c 3b 11 80       	mov    %eax,0x80113b8c
  if (i == log.lh.n)
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
    panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 53 85 10 80       	push   $0x80108553
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 69 85 10 80       	push   $0x80108569
80102e4b:	e8 40 d5 ff ff       	call   80100390 <panic>

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e57:	e8 c4 0a 00 00       	call   80103920 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 bd 0a 00 00       	call   80103920 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 84 85 10 80       	push   $0x80108584
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e72:	e8 39 3a 00 00       	call   801068b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 24 0a 00 00       	call   801038a0 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e8a:	e8 71 0d 00 00       	call   80103c00 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e96:	e8 05 4b 00 00       	call   801079a0 <switchkvm>
  seginit();
80102e9b:	e8 70 4a 00 00       	call   80107910 <seginit>
  lapicinit();
80102ea0:	e8 9b f7 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102ea5:	e8 a6 ff ff ff       	call   80102e50 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102eb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102eb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 00 00 40 80       	push   $0x80400000
80102ec7:	68 e8 39 13 80       	push   $0x801339e8
80102ecc:	e8 2f f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102ed1:	e8 9a 4f 00 00       	call   80107e70 <kvmalloc>
  mpinit();        // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
  lapicinit();     // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102ee0:	e8 2b 4a 00 00       	call   80107910 <seginit>
  picinit();       // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eea:	e8 41 f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ef4:	e8 e7 3c 00 00       	call   80106be0 <uartinit>
  pinit();         // process table
80102ef9:	e8 82 09 00 00       	call   80103880 <pinit>
  tvinit();        // trap vectors
80102efe:	e8 2d 39 00 00       	call   80106830 <tvinit>
  binit();         // buffer cache
80102f03:	e8 38 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f08:	e8 53 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f0d:	e8 fe f0 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f12:	83 c4 0c             	add    $0xc,%esp
80102f15:	68 8a 00 00 00       	push   $0x8a
80102f1a:	68 8c b8 10 80       	push   $0x8010b88c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 e7 23 00 00       	call   80105310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f29:	69 05 c0 41 11 80 b0 	imul   $0xb0,0x801141c0,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 40 3c 11 80       	add    $0x80113c40,%eax
80102f3b:	3d 40 3c 11 80       	cmp    $0x80113c40,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 40 3c 11 80       	mov    $0x80113c40,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f50:	e8 4b 09 00 00       	call   801038a0 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f59:	e8 72 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f63:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f6a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f74:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 70 00 00       	push   $0x7000
80102f87:	50                   	push   %eax
80102f88:	e8 03 f8 ff ff       	call   80102790 <lapicstartap>
80102f8d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f9a:	69 05 c0 41 11 80 b0 	imul   $0xb0,0x801141c0,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 40 3c 11 80       	add    $0x80113c40,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 ab f4 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102fc5:	e8 a6 09 00 00       	call   80103970 <userinit>
  mpmain();        // finish this processor's setup
80102fca:	e8 81 fe ff ff       	call   80102e50 <mpmain>
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fdb:	53                   	push   %ebx
  e = addr+len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	72 10                	jb     80102ff6 <mpsearch1+0x26>
80102fe6:	eb 50                	jmp    80103038 <mpsearch1+0x68>
80102fe8:	90                   	nop
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	76 42                	jbe    80103038 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	83 ec 04             	sub    $0x4,%esp
80102ff9:	8d 7e 10             	lea    0x10(%esi),%edi
80102ffc:	6a 04                	push   $0x4
80102ffe:	68 98 85 10 80       	push   $0x80108598
80103003:	56                   	push   %esi
80103004:	e8 a7 22 00 00       	call   801052b0 <memcmp>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	85 c0                	test   %eax,%eax
8010300e:	75 e0                	jne    80102ff0 <mpsearch1+0x20>
80103010:	89 f1                	mov    %esi,%ecx
80103012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103018:	0f b6 11             	movzbl (%ecx),%edx
8010301b:	83 c1 01             	add    $0x1,%ecx
8010301e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103020:	39 f9                	cmp    %edi,%ecx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103024:	84 c0                	test   %al,%al
80103026:	75 c8                	jne    80102ff0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	89 f0                	mov    %esi,%eax
8010302d:	5b                   	pop    %ebx
8010302e:	5e                   	pop    %esi
8010302f:	5f                   	pop    %edi
80103030:	5d                   	pop    %ebp
80103031:	c3                   	ret    
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010303b:	31 f6                	xor    %esi,%esi
}
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
80103044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010304a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010309d:	0f 84 3d 01 00 00    	je     801031e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a6:	8b 58 04             	mov    0x4(%eax),%ebx
801030a9:	85 db                	test   %ebx,%ebx
801030ab:	0f 84 4f 01 00 00    	je     80103200 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030b7:	83 ec 04             	sub    $0x4,%esp
801030ba:	6a 04                	push   $0x4
801030bc:	68 b5 85 10 80       	push   $0x801085b5
801030c1:	56                   	push   %esi
801030c2:	e8 e9 21 00 00       	call   801052b0 <memcmp>
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c0                	test   %eax,%eax
801030cc:	0f 85 2e 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d9:	3c 01                	cmp    $0x1,%al
801030db:	0f 95 c2             	setne  %dl
801030de:	3c 04                	cmp    $0x4,%al
801030e0:	0f 95 c0             	setne  %al
801030e3:	20 c2                	and    %al,%dl
801030e5:	0f 85 15 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030f2:	66 85 ff             	test   %di,%di
801030f5:	74 1a                	je     80103111 <mpinit+0xc1>
801030f7:	89 f0                	mov    %esi,%eax
801030f9:	01 f7                	add    %esi,%edi
  sum = 0;
801030fb:	31 d2                	xor    %edx,%edx
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103100:	0f b6 08             	movzbl (%eax),%ecx
80103103:	83 c0 01             	add    $0x1,%eax
80103106:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103108:	39 c7                	cmp    %eax,%edi
8010310a:	75 f4                	jne    80103100 <mpinit+0xb0>
8010310c:	84 d2                	test   %dl,%dl
8010310e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103111:	85 f6                	test   %esi,%esi
80103113:	0f 84 e7 00 00 00    	je     80103200 <mpinit+0x1b0>
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 df 00 00 00    	jne    80103200 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103121:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103127:	a3 3c 3b 11 80       	mov    %eax,0x80113b3c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103133:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103139:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313e:	01 d6                	add    %edx,%esi
80103140:	39 c6                	cmp    %eax,%esi
80103142:	76 23                	jbe    80103167 <mpinit+0x117>
    switch(*p){
80103144:	0f b6 10             	movzbl (%eax),%edx
80103147:	80 fa 04             	cmp    $0x4,%dl
8010314a:	0f 87 ca 00 00 00    	ja     8010321a <mpinit+0x1ca>
80103150:	ff 24 95 dc 85 10 80 	jmp    *-0x7fef7a24(,%edx,4)
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103160:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103163:	39 c6                	cmp    %eax,%esi
80103165:	77 dd                	ja     80103144 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103167:	85 db                	test   %ebx,%ebx
80103169:	0f 84 9e 00 00 00    	je     8010320d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103172:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103176:	74 15                	je     8010318d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103178:	b8 70 00 00 00       	mov    $0x70,%eax
8010317d:	ba 22 00 00 00       	mov    $0x22,%edx
80103182:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103183:	ba 23 00 00 00       	mov    $0x23,%edx
80103188:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103189:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318c:	ee                   	out    %al,(%dx)
  }
}
8010318d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103190:	5b                   	pop    %ebx
80103191:	5e                   	pop    %esi
80103192:	5f                   	pop    %edi
80103193:	5d                   	pop    %ebp
80103194:	c3                   	ret    
80103195:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103198:	8b 0d c0 41 11 80    	mov    0x801141c0,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d c0 41 11 80    	mov    %ecx,0x801141c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b6:	88 97 40 3c 11 80    	mov    %dl,-0x7feec3c0(%edi)
      p += sizeof(struct mpproc);
801031bc:	83 c0 14             	add    $0x14,%eax
      continue;
801031bf:	e9 7c ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031cf:	88 15 20 3c 11 80    	mov    %dl,0x80113c20
      continue;
801031d5:	e9 66 ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f4:	0f 85 a9 fe ff ff    	jne    801030a3 <mpinit+0x53>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 9d 85 10 80       	push   $0x8010859d
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 bc 85 10 80       	push   $0x801085bc
80103215:	e8 76 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010321a:	31 db                	xor    %ebx,%ebx
8010321c:	e9 26 ff ff ff       	jmp    80103147 <mpinit+0xf7>
80103221:	66 90                	xchg   %ax,%ax
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 10 db ff ff       	call   80100d80 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 05 db ff ff       	call   80100d80 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103281:	e8 4a f2 ff ff       	call   801024d0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
    fileclose(*f1);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 99 db ff ff       	call   80100e40 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 71 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
  p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
  p->nwrite = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
  p->nread = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
  initlock(&p->lock, "pipe");
8010330b:	68 f0 85 10 80       	push   $0x801085f0
80103310:	50                   	push   %eax
80103311:	e8 fa 1c 00 00       	call   80105010 <initlock>
  (*f0)->type = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
  return 0;
80103318:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 dc 1d 00 00       	call   80105150 <acquire>
  if(writable){
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
    wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 0c 0d 00 00       	call   801040a0 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
    release(&p->lock);
801033b4:	e9 57 1e 00 00       	jmp    80105210 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
    wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 c7 0c 00 00       	call   801040a0 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 27 1e 00 00       	call   80105210 <release>
    kfree((char*)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
    kfree((char*)p);
801033f5:	e9 26 ef ff ff       	jmp    80102320 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 3e 1d 00 00       	call   80105150 <acquire>
  for(i = 0; i < n; i++){
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 71                	jne    801034b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 4e                	je     801034a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 37 0c 00 00       	call   801040a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 6e 0a 00 00       	call   80103ee0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0c                	je     801034a0 <pipewrite+0xa0>
80103494:	e8 a7 04 00 00       	call   80103940 <myproc>
80103499:	8b 40 24             	mov    0x24(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
        release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 67 1d 00 00       	call   80105210 <release>
        return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 a8 0b 00 00       	call   801040a0 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 10 1d 00 00       	call   80105210 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xb1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 2b 1c 00 00       	call   80105150 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 c4 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 86 09 00 00       	call   80103ee0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
80103579:	e8 c2 03 00 00       	call   80103940 <myproc>
8010357e:	8b 48 24             	mov    0x24(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 7d 1c 00 00       	call   80105210 <release>
      return -1;
80103593:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103599:	89 d8                	mov    %ebx,%eax
8010359b:	5b                   	pop    %ebx
8010359c:	5e                   	pop    %esi
8010359d:	5f                   	pop    %edi
8010359e:	5d                   	pop    %ebp
8010359f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 61                	jle    80103608 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035a7:	31 db                	xor    %ebx,%ebx
801035a9:	eb 13                	jmp    801035be <piperead+0xae>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035bc:	74 1f                	je     801035dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035be:	8d 41 01             	lea    0x1(%ecx),%eax
801035c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	83 c3 01             	add    $0x1,%ebx
801035d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035db:	75 d3                	jne    801035b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 b4 0a 00 00       	call   801040a0 <wakeup>
  release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 1c 1c 00 00       	call   80105210 <release>
  return i;
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	89 d8                	mov    %ebx,%eax
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	31 db                	xor    %ebx,%ebx
8010360a:	eb d1                	jmp    801035dd <piperead+0xcd>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103614:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
{
80103619:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010361c:	68 60 0f 13 80       	push   $0x80130f60
80103621:	e8 2a 1b 00 00       	call   80105150 <acquire>
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	eb 17                	jmp    80103642 <allocproc+0x32>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103630:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103636:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
8010363c:	0f 83 7e 00 00 00    	jae    801036c0 <allocproc+0xb0>
    if(p->state == UNUSED)
80103642:	8b 43 0c             	mov    0xc(%ebx),%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 e7                	jne    80103630 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103649:	a1 04 b4 10 80       	mov    0x8010b404,%eax
  p->container_id = -1;
  
  release(&ptable.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103651:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->container_id = -1;
80103658:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
8010365f:	ff ff ff 
  p->pid = nextpid++;
80103662:	8d 50 01             	lea    0x1(%eax),%edx
80103665:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103668:	68 60 0f 13 80       	push   $0x80130f60
  p->pid = nextpid++;
8010366d:	89 15 04 b4 10 80    	mov    %edx,0x8010b404
  release(&ptable.lock);
80103673:	e8 98 1b 00 00       	call   80105210 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103678:	e8 53 ee ff ff       	call   801024d0 <kalloc>
8010367d:	83 c4 10             	add    $0x10,%esp
80103680:	85 c0                	test   %eax,%eax
80103682:	89 43 08             	mov    %eax,0x8(%ebx)
80103685:	74 52                	je     801036d9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103687:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010368d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103690:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103695:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103698:	c7 40 14 17 68 10 80 	movl   $0x80106817,0x14(%eax)
  p->context = (struct context*)sp;
8010369f:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036a2:	6a 14                	push   $0x14
801036a4:	6a 00                	push   $0x0
801036a6:	50                   	push   %eax
801036a7:	e8 b4 1b 00 00       	call   80105260 <memset>
  p->context->eip = (uint)forkret;
801036ac:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036af:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036b2:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
}
801036b9:	89 d8                	mov    %ebx,%eax
801036bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036be:	c9                   	leave  
801036bf:	c3                   	ret    
  release(&ptable.lock);
801036c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036c5:	68 60 0f 13 80       	push   $0x80130f60
801036ca:	e8 41 1b 00 00       	call   80105210 <release>
}
801036cf:	89 d8                	mov    %ebx,%eax
  return 0;
801036d1:	83 c4 10             	add    $0x10,%esp
}
801036d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036d7:	c9                   	leave  
801036d8:	c3                   	ret    
    p->state = UNUSED;
801036d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036e0:	31 db                	xor    %ebx,%ebx
801036e2:	eb d5                	jmp    801036b9 <allocproc+0xa9>
801036e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036f6:	68 60 0f 13 80       	push   $0x80130f60
801036fb:	e8 10 1b 00 00       	call   80105210 <release>

  if (first) {
80103700:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 04                	jne    80103710 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103710:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103713:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010371a:	00 00 00 
    iinit(ROOTDEV);
8010371d:	6a 01                	push   $0x1
8010371f:	e8 6c dd ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 e0 f3 ff ff       	call   80102b10 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <isEmpty>:
{  return (q->size == 0); } 
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	8b 45 08             	mov    0x8(%ebp),%eax
80103746:	5d                   	pop    %ebp
80103747:	8b 40 3c             	mov    0x3c(%eax),%eax
8010374a:	85 c0                	test   %eax,%eax
8010374c:	0f 94 c0             	sete   %al
8010374f:	0f b6 c0             	movzbl %al,%eax
80103752:	c3                   	ret    
80103753:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103760 <print_queue>:
{  
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
80103765:	8b 75 08             	mov    0x8(%ebp),%esi
  for(int i=q->front+1;i<=q->rear;i++)
80103768:	8b 46 34             	mov    0x34(%esi),%eax
8010376b:	8d 58 01             	lea    0x1(%eax),%ebx
8010376e:	3b 5e 38             	cmp    0x38(%esi),%ebx
80103771:	7f 21                	jg     80103794 <print_queue+0x34>
80103773:	90                   	nop
80103774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("   queue element: %d\n", *(int*)q->array[i] );
80103778:	83 ec 08             	sub    $0x8,%esp
8010377b:	ff 74 de 44          	pushl  0x44(%esi,%ebx,8)
  for(int i=q->front+1;i<=q->rear;i++)
8010377f:	83 c3 01             	add    $0x1,%ebx
    cprintf("   queue element: %d\n", *(int*)q->array[i] );
80103782:	68 f5 85 10 80       	push   $0x801085f5
80103787:	e8 d4 ce ff ff       	call   80100660 <cprintf>
  for(int i=q->front+1;i<=q->rear;i++)
8010378c:	83 c4 10             	add    $0x10,%esp
8010378f:	39 5e 38             	cmp    %ebx,0x38(%esi)
80103792:	7d e4                	jge    80103778 <print_queue+0x18>
} 
80103794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103797:	5b                   	pop    %ebx
80103798:	5e                   	pop    %esi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	90                   	nop
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037a0 <enqueue>:
{ 
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	57                   	push   %edi
801037a4:	56                   	push   %esi
801037a5:	53                   	push   %ebx
801037a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    if (q->size == MSGBUFFSIZE) 
801037ac:	8b 73 3c             	mov    0x3c(%ebx),%esi
801037af:	81 fe c8 00 00 00    	cmp    $0xc8,%esi
801037b5:	74 46                	je     801037fd <enqueue+0x5d>
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
801037b7:	8b 43 38             	mov    0x38(%ebx),%eax
801037ba:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801037bf:	8d 78 01             	lea    0x1(%eax),%edi
801037c2:	89 f8                	mov    %edi,%eax
801037c4:	f7 ea                	imul   %edx
801037c6:	89 f8                	mov    %edi,%eax
801037c8:	c1 f8 1f             	sar    $0x1f,%eax
801037cb:	c1 fa 06             	sar    $0x6,%edx
801037ce:	29 c2                	sub    %eax,%edx
    for(int i=0;i<8;i++)
801037d0:	31 c0                	xor    %eax,%eax
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
801037d2:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
801037d8:	29 d7                	sub    %edx,%edi
801037da:	89 7b 38             	mov    %edi,0x38(%ebx)
801037dd:	8d 3c fb             	lea    (%ebx,%edi,8),%edi
      q->array[q->rear][i] = *item; 
801037e0:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
801037e4:	88 54 07 44          	mov    %dl,0x44(%edi,%eax,1)
    for(int i=0;i<8;i++)
801037e8:	83 c0 01             	add    $0x1,%eax
801037eb:	83 f8 08             	cmp    $0x8,%eax
801037ee:	75 f0                	jne    801037e0 <enqueue+0x40>
    q->size = q->size + 1; 
801037f0:	83 c6 01             	add    $0x1,%esi
    return 0; 
801037f3:	31 c0                	xor    %eax,%eax
    q->size = q->size + 1; 
801037f5:	89 73 3c             	mov    %esi,0x3c(%ebx)
} 
801037f8:	5b                   	pop    %ebx
801037f9:	5e                   	pop    %esi
801037fa:	5f                   	pop    %edi
801037fb:	5d                   	pop    %ebp
801037fc:	c3                   	ret    
      return -1; 
801037fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103802:	eb f4                	jmp    801037f8 <enqueue+0x58>
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <dequeue>:
{ 
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	53                   	push   %ebx
80103815:	8b 5d 08             	mov    0x8(%ebp),%ebx
{  return (q->size == 0); } 
80103818:	8b 73 3c             	mov    0x3c(%ebx),%esi
    if (isEmpty(q)) 
8010381b:	85 f6                	test   %esi,%esi
8010381d:	74 31                	je     80103850 <dequeue+0x40>
    q->front = (q->front + 1)%MSGBUFFSIZE; 
8010381f:	8b 43 34             	mov    0x34(%ebx),%eax
80103822:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    q->size = q->size - 1; 
80103827:	83 ee 01             	sub    $0x1,%esi
8010382a:	89 73 3c             	mov    %esi,0x3c(%ebx)
    q->front = (q->front + 1)%MSGBUFFSIZE; 
8010382d:	8d 48 01             	lea    0x1(%eax),%ecx
80103830:	89 c8                	mov    %ecx,%eax
80103832:	f7 ea                	imul   %edx
80103834:	89 c8                	mov    %ecx,%eax
80103836:	c1 f8 1f             	sar    $0x1f,%eax
80103839:	c1 fa 06             	sar    $0x6,%edx
8010383c:	29 c2                	sub    %eax,%edx
    return 0; 
8010383e:	31 c0                	xor    %eax,%eax
    q->front = (q->front + 1)%MSGBUFFSIZE; 
80103840:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
80103846:	29 d1                	sub    %edx,%ecx
80103848:	89 4b 34             	mov    %ecx,0x34(%ebx)
} 
8010384b:	5b                   	pop    %ebx
8010384c:	5e                   	pop    %esi
8010384d:	5d                   	pop    %ebp
8010384e:	c3                   	ret    
8010384f:	90                   	nop
        return -1; 
80103850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103855:	eb f4                	jmp    8010384b <dequeue+0x3b>
80103857:	89 f6                	mov    %esi,%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <rear>:
{ 
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103866:	5d                   	pop    %ebp
    return q->array[q->rear]; 
80103867:	8b 50 38             	mov    0x38(%eax),%edx
8010386a:	8d 44 d0 44          	lea    0x44(%eax,%edx,8),%eax
}
8010386e:	c3                   	ret    
8010386f:	90                   	nop

80103870 <front>:
{ 
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	8b 45 08             	mov    0x8(%ebp),%eax
} 
80103876:	5d                   	pop    %ebp
    return q->array[q->front+1]; 
80103877:	8b 50 34             	mov    0x34(%eax),%edx
8010387a:	8d 44 d0 4c          	lea    0x4c(%eax,%edx,8),%eax
} 
8010387e:	c3                   	ret    
8010387f:	90                   	nop

80103880 <pinit>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103886:	68 0b 86 10 80       	push   $0x8010860b
8010388b:	68 60 0f 13 80       	push   $0x80130f60
80103890:	e8 7b 17 00 00       	call   80105010 <initlock>
}
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	c9                   	leave  
80103899:	c3                   	ret    
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038a0 <mycpu>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038a5:	9c                   	pushf  
801038a6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038a7:	f6 c4 02             	test   $0x2,%ah
801038aa:	75 5e                	jne    8010390a <mycpu+0x6a>
  apicid = lapicid();
801038ac:	e8 8f ee ff ff       	call   80102740 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038b1:	8b 35 c0 41 11 80    	mov    0x801141c0,%esi
801038b7:	85 f6                	test   %esi,%esi
801038b9:	7e 42                	jle    801038fd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038bb:	0f b6 15 40 3c 11 80 	movzbl 0x80113c40,%edx
801038c2:	39 d0                	cmp    %edx,%eax
801038c4:	74 30                	je     801038f6 <mycpu+0x56>
801038c6:	b9 f0 3c 11 80       	mov    $0x80113cf0,%ecx
  for (i = 0; i < ncpu; ++i) {
801038cb:	31 d2                	xor    %edx,%edx
801038cd:	8d 76 00             	lea    0x0(%esi),%esi
801038d0:	83 c2 01             	add    $0x1,%edx
801038d3:	39 f2                	cmp    %esi,%edx
801038d5:	74 26                	je     801038fd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038d7:	0f b6 19             	movzbl (%ecx),%ebx
801038da:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038e0:	39 c3                	cmp    %eax,%ebx
801038e2:	75 ec                	jne    801038d0 <mycpu+0x30>
801038e4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038ea:	05 40 3c 11 80       	add    $0x80113c40,%eax
}
801038ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f2:	5b                   	pop    %ebx
801038f3:	5e                   	pop    %esi
801038f4:	5d                   	pop    %ebp
801038f5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038f6:	b8 40 3c 11 80       	mov    $0x80113c40,%eax
      return &cpus[i];
801038fb:	eb f2                	jmp    801038ef <mycpu+0x4f>
  panic("unknown apicid\n");
801038fd:	83 ec 0c             	sub    $0xc,%esp
80103900:	68 12 86 10 80       	push   $0x80108612
80103905:	e8 86 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	68 d8 87 10 80       	push   $0x801087d8
80103912:	e8 79 ca ff ff       	call   80100390 <panic>
80103917:	89 f6                	mov    %esi,%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103920 <cpuid>:
cpuid() {
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103926:	e8 75 ff ff ff       	call   801038a0 <mycpu>
8010392b:	2d 40 3c 11 80       	sub    $0x80113c40,%eax
}
80103930:	c9                   	leave  
  return mycpu()-cpus;
80103931:	c1 f8 04             	sar    $0x4,%eax
80103934:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010393a:	c3                   	ret    
8010393b:	90                   	nop
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <myproc>:
myproc(void) {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103947:	e8 34 17 00 00       	call   80105080 <pushcli>
  c = mycpu();
8010394c:	e8 4f ff ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103951:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103957:	e8 64 17 00 00       	call   801050c0 <popcli>
}
8010395c:	83 c4 04             	add    $0x4,%esp
8010395f:	89 d8                	mov    %ebx,%eax
80103961:	5b                   	pop    %ebx
80103962:	5d                   	pop    %ebp
80103963:	c3                   	ret    
80103964:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010396a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103970 <userinit>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103977:	e8 94 fc ff ff       	call   80103610 <allocproc>
8010397c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010397e:	a3 68 ba 10 80       	mov    %eax,0x8010ba68
  if((p->pgdir = setupkvm()) == 0)
80103983:	e8 68 44 00 00       	call   80107df0 <setupkvm>
80103988:	85 c0                	test   %eax,%eax
8010398a:	89 43 04             	mov    %eax,0x4(%ebx)
8010398d:	0f 84 bd 00 00 00    	je     80103a50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103993:	83 ec 04             	sub    $0x4,%esp
80103996:	68 2c 00 00 00       	push   $0x2c
8010399b:	68 60 b8 10 80       	push   $0x8010b860
801039a0:	50                   	push   %eax
801039a1:	e8 2a 41 00 00       	call   80107ad0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039a6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039a9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039af:	6a 4c                	push   $0x4c
801039b1:	6a 00                	push   $0x0
801039b3:	ff 73 18             	pushl  0x18(%ebx)
801039b6:	e8 a5 18 00 00       	call   80105260 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039bb:	8b 43 18             	mov    0x18(%ebx),%eax
801039be:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039c3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039c8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039cb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039cf:	8b 43 18             	mov    0x18(%ebx),%eax
801039d2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039d6:	8b 43 18             	mov    0x18(%ebx),%eax
801039d9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039dd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039e1:	8b 43 18             	mov    0x18(%ebx),%eax
801039e4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039e8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039ec:	8b 43 18             	mov    0x18(%ebx),%eax
801039ef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039f6:	8b 43 18             	mov    0x18(%ebx),%eax
801039f9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a00:	8b 43 18             	mov    0x18(%ebx),%eax
80103a03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a0d:	6a 10                	push   $0x10
80103a0f:	68 3b 86 10 80       	push   $0x8010863b
80103a14:	50                   	push   %eax
80103a15:	e8 26 1a 00 00       	call   80105440 <safestrcpy>
  p->cwd = namei("/");
80103a1a:	c7 04 24 44 86 10 80 	movl   $0x80108644,(%esp)
80103a21:	e8 ca e4 ff ff       	call   80101ef0 <namei>
80103a26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a29:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103a30:	e8 1b 17 00 00       	call   80105150 <acquire>
  p->state = RUNNABLE;
80103a35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a3c:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103a43:	e8 c8 17 00 00       	call   80105210 <release>
}
80103a48:	83 c4 10             	add    $0x10,%esp
80103a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a4e:	c9                   	leave  
80103a4f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	68 22 86 10 80       	push   $0x80108622
80103a58:	e8 33 c9 ff ff       	call   80100390 <panic>
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi

80103a60 <growproc>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
80103a65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a68:	e8 13 16 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103a6d:	e8 2e fe ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103a72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a78:	e8 43 16 00 00       	call   801050c0 <popcli>
  if(n > 0){
80103a7d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a82:	7f 1c                	jg     80103aa0 <growproc+0x40>
  } else if(n < 0){
80103a84:	75 3a                	jne    80103ac0 <growproc+0x60>
  switchuvm(curproc);
80103a86:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a89:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a8b:	53                   	push   %ebx
80103a8c:	e8 2f 3f 00 00       	call   801079c0 <switchuvm>
  return 0;
80103a91:	83 c4 10             	add    $0x10,%esp
80103a94:	31 c0                	xor    %eax,%eax
}
80103a96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a99:	5b                   	pop    %ebx
80103a9a:	5e                   	pop    %esi
80103a9b:	5d                   	pop    %ebp
80103a9c:	c3                   	ret    
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 61 41 00 00       	call   80107c10 <allocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 d0                	jne    80103a86 <growproc+0x26>
      return -1;
80103ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103abb:	eb d9                	jmp    80103a96 <growproc+0x36>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ac0:	83 ec 04             	sub    $0x4,%esp
80103ac3:	01 c6                	add    %eax,%esi
80103ac5:	56                   	push   %esi
80103ac6:	50                   	push   %eax
80103ac7:	ff 73 04             	pushl  0x4(%ebx)
80103aca:	e8 71 42 00 00       	call   80107d40 <deallocuvm>
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	75 b0                	jne    80103a86 <growproc+0x26>
80103ad6:	eb de                	jmp    80103ab6 <growproc+0x56>
80103ad8:	90                   	nop
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <fork>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ae9:	e8 92 15 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103aee:	e8 ad fd ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103af3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af9:	e8 c2 15 00 00       	call   801050c0 <popcli>
  if((np = allocproc()) == 0){
80103afe:	e8 0d fb ff ff       	call   80103610 <allocproc>
80103b03:	85 c0                	test   %eax,%eax
80103b05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b08:	0f 84 b7 00 00 00    	je     80103bc5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b0e:	83 ec 08             	sub    $0x8,%esp
80103b11:	ff 33                	pushl  (%ebx)
80103b13:	ff 73 04             	pushl  0x4(%ebx)
80103b16:	89 c7                	mov    %eax,%edi
80103b18:	e8 a3 43 00 00       	call   80107ec0 <copyuvm>
80103b1d:	83 c4 10             	add    $0x10,%esp
80103b20:	85 c0                	test   %eax,%eax
80103b22:	89 47 04             	mov    %eax,0x4(%edi)
80103b25:	0f 84 a1 00 00 00    	je     80103bcc <fork+0xec>
  np->sz = curproc->sz;
80103b2b:	8b 03                	mov    (%ebx),%eax
80103b2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b30:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b32:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b35:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b37:	8b 79 18             	mov    0x18(%ecx),%edi
80103b3a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b3d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b46:	8b 40 18             	mov    0x18(%eax),%eax
80103b49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b54:	85 c0                	test   %eax,%eax
80103b56:	74 13                	je     80103b6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b58:	83 ec 0c             	sub    $0xc,%esp
80103b5b:	50                   	push   %eax
80103b5c:	e8 8f d2 ff ff       	call   80100df0 <filedup>
80103b61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b64:	83 c4 10             	add    $0x10,%esp
80103b67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b6b:	83 c6 01             	add    $0x1,%esi
80103b6e:	83 fe 10             	cmp    $0x10,%esi
80103b71:	75 dd                	jne    80103b50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b73:	83 ec 0c             	sub    $0xc,%esp
80103b76:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b7c:	e8 df da ff ff       	call   80101660 <idup>
80103b81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b8d:	6a 10                	push   $0x10
80103b8f:	53                   	push   %ebx
80103b90:	50                   	push   %eax
80103b91:	e8 aa 18 00 00       	call   80105440 <safestrcpy>
  pid = np->pid;
80103b96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b99:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103ba0:	e8 ab 15 00 00       	call   80105150 <acquire>
  np->state = RUNNABLE;
80103ba5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bac:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103bb3:	e8 58 16 00 00       	call   80105210 <release>
  return pid;
80103bb8:	83 c4 10             	add    $0x10,%esp
}
80103bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bbe:	89 d8                	mov    %ebx,%eax
80103bc0:	5b                   	pop    %ebx
80103bc1:	5e                   	pop    %esi
80103bc2:	5f                   	pop    %edi
80103bc3:	5d                   	pop    %ebp
80103bc4:	c3                   	ret    
    return -1;
80103bc5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bca:	eb ef                	jmp    80103bbb <fork+0xdb>
    kfree(np->kstack);
80103bcc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bcf:	83 ec 0c             	sub    $0xc,%esp
80103bd2:	ff 73 08             	pushl  0x8(%ebx)
80103bd5:	e8 46 e7 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103bda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103be1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103be8:	83 c4 10             	add    $0x10,%esp
80103beb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bf0:	eb c9                	jmp    80103bbb <fork+0xdb>
80103bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <scheduler>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c09:	e8 92 fc ff ff       	call   801038a0 <mycpu>
80103c0e:	8d 78 04             	lea    0x4(%eax),%edi
80103c11:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c1a:	00 00 00 
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c20:	fb                   	sti    
    acquire(&ptable.lock);
80103c21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c24:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
    acquire(&ptable.lock);
80103c29:	68 60 0f 13 80       	push   $0x80130f60
80103c2e:	e8 1d 15 00 00       	call   80105150 <acquire>
80103c33:	83 c4 10             	add    $0x10,%esp
80103c36:	8d 76 00             	lea    0x0(%esi),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103c40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c44:	75 33                	jne    80103c79 <scheduler+0x79>
      switchuvm(p);
80103c46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c4f:	53                   	push   %ebx
80103c50:	e8 6b 3d 00 00       	call   801079c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c55:	58                   	pop    %eax
80103c56:	5a                   	pop    %edx
80103c57:	ff 73 1c             	pushl  0x1c(%ebx)
80103c5a:	57                   	push   %edi
      p->state = RUNNING;
80103c5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c62:	e8 34 18 00 00       	call   8010549b <swtch>
      switchkvm();
80103c67:	e8 34 3d 00 00       	call   801079a0 <switchkvm>
      c->proc = 0;
80103c6c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c73:	00 00 00 
80103c76:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c79:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103c7f:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
80103c85:	72 b9                	jb     80103c40 <scheduler+0x40>
    release(&ptable.lock);
80103c87:	83 ec 0c             	sub    $0xc,%esp
80103c8a:	68 60 0f 13 80       	push   $0x80130f60
80103c8f:	e8 7c 15 00 00       	call   80105210 <release>
    sti();
80103c94:	83 c4 10             	add    $0x10,%esp
80103c97:	eb 87                	jmp    80103c20 <scheduler+0x20>
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <sched>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
  pushcli();
80103ca5:	e8 d6 13 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103caa:	e8 f1 fb ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103caf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cb5:	e8 06 14 00 00       	call   801050c0 <popcli>
  if(!holding(&ptable.lock))
80103cba:	83 ec 0c             	sub    $0xc,%esp
80103cbd:	68 60 0f 13 80       	push   $0x80130f60
80103cc2:	e8 59 14 00 00       	call   80105120 <holding>
80103cc7:	83 c4 10             	add    $0x10,%esp
80103cca:	85 c0                	test   %eax,%eax
80103ccc:	74 4f                	je     80103d1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cce:	e8 cd fb ff ff       	call   801038a0 <mycpu>
80103cd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cda:	75 68                	jne    80103d44 <sched+0xa4>
  if(p->state == RUNNING)
80103cdc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ce0:	74 55                	je     80103d37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ce2:	9c                   	pushf  
80103ce3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ce4:	f6 c4 02             	test   $0x2,%ah
80103ce7:	75 41                	jne    80103d2a <sched+0x8a>
  intena = mycpu()->intena;
80103ce9:	e8 b2 fb ff ff       	call   801038a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103cf1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cf7:	e8 a4 fb ff ff       	call   801038a0 <mycpu>
80103cfc:	83 ec 08             	sub    $0x8,%esp
80103cff:	ff 70 04             	pushl  0x4(%eax)
80103d02:	53                   	push   %ebx
80103d03:	e8 93 17 00 00       	call   8010549b <swtch>
  mycpu()->intena = intena;
80103d08:	e8 93 fb ff ff       	call   801038a0 <mycpu>
}
80103d0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d19:	5b                   	pop    %ebx
80103d1a:	5e                   	pop    %esi
80103d1b:	5d                   	pop    %ebp
80103d1c:	c3                   	ret    
    panic("sched ptable.lock");
80103d1d:	83 ec 0c             	sub    $0xc,%esp
80103d20:	68 46 86 10 80       	push   $0x80108646
80103d25:	e8 66 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	68 72 86 10 80       	push   $0x80108672
80103d32:	e8 59 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	68 64 86 10 80       	push   $0x80108664
80103d3f:	e8 4c c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	68 58 86 10 80       	push   $0x80108658
80103d4c:	e8 3f c6 ff ff       	call   80100390 <panic>
80103d51:	eb 0d                	jmp    80103d60 <exit>
80103d53:	90                   	nop
80103d54:	90                   	nop
80103d55:	90                   	nop
80103d56:	90                   	nop
80103d57:	90                   	nop
80103d58:	90                   	nop
80103d59:	90                   	nop
80103d5a:	90                   	nop
80103d5b:	90                   	nop
80103d5c:	90                   	nop
80103d5d:	90                   	nop
80103d5e:	90                   	nop
80103d5f:	90                   	nop

80103d60 <exit>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d69:	e8 12 13 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103d6e:	e8 2d fb ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103d73:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d79:	e8 42 13 00 00       	call   801050c0 <popcli>
  if(curproc == initproc)
80103d7e:	39 35 68 ba 10 80    	cmp    %esi,0x8010ba68
80103d84:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d87:	8d 7e 68             	lea    0x68(%esi),%edi
80103d8a:	0f 84 f1 00 00 00    	je     80103e81 <exit+0x121>
    if(curproc->ofile[fd]){
80103d90:	8b 03                	mov    (%ebx),%eax
80103d92:	85 c0                	test   %eax,%eax
80103d94:	74 12                	je     80103da8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d96:	83 ec 0c             	sub    $0xc,%esp
80103d99:	50                   	push   %eax
80103d9a:	e8 a1 d0 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103d9f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103da5:	83 c4 10             	add    $0x10,%esp
80103da8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103dab:	39 fb                	cmp    %edi,%ebx
80103dad:	75 e1                	jne    80103d90 <exit+0x30>
  begin_op();
80103daf:	e8 fc ed ff ff       	call   80102bb0 <begin_op>
  iput(curproc->cwd);
80103db4:	83 ec 0c             	sub    $0xc,%esp
80103db7:	ff 76 68             	pushl  0x68(%esi)
80103dba:	e8 01 da ff ff       	call   801017c0 <iput>
  end_op();
80103dbf:	e8 5c ee ff ff       	call   80102c20 <end_op>
  curproc->cwd = 0;
80103dc4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103dcb:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103dd2:	e8 79 13 00 00       	call   80105150 <acquire>
  wakeup1(curproc->parent);
80103dd7:	8b 56 14             	mov    0x14(%esi),%edx
80103dda:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ddd:	b8 94 0f 13 80       	mov    $0x80130f94,%eax
80103de2:	eb 10                	jmp    80103df4 <exit+0x94>
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de8:	05 88 00 00 00       	add    $0x88,%eax
80103ded:	3d 94 31 13 80       	cmp    $0x80133194,%eax
80103df2:	73 1e                	jae    80103e12 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103df4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103df8:	75 ee                	jne    80103de8 <exit+0x88>
80103dfa:	3b 50 20             	cmp    0x20(%eax),%edx
80103dfd:	75 e9                	jne    80103de8 <exit+0x88>
      p->state = RUNNABLE;
80103dff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e06:	05 88 00 00 00       	add    $0x88,%eax
80103e0b:	3d 94 31 13 80       	cmp    $0x80133194,%eax
80103e10:	72 e2                	jb     80103df4 <exit+0x94>
      p->parent = initproc;
80103e12:	8b 0d 68 ba 10 80    	mov    0x8010ba68,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e18:	ba 94 0f 13 80       	mov    $0x80130f94,%edx
80103e1d:	eb 0f                	jmp    80103e2e <exit+0xce>
80103e1f:	90                   	nop
80103e20:	81 c2 88 00 00 00    	add    $0x88,%edx
80103e26:	81 fa 94 31 13 80    	cmp    $0x80133194,%edx
80103e2c:	73 3a                	jae    80103e68 <exit+0x108>
    if(p->parent == curproc){
80103e2e:	39 72 14             	cmp    %esi,0x14(%edx)
80103e31:	75 ed                	jne    80103e20 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e33:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e37:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e3a:	75 e4                	jne    80103e20 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3c:	b8 94 0f 13 80       	mov    $0x80130f94,%eax
80103e41:	eb 11                	jmp    80103e54 <exit+0xf4>
80103e43:	90                   	nop
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e48:	05 88 00 00 00       	add    $0x88,%eax
80103e4d:	3d 94 31 13 80       	cmp    $0x80133194,%eax
80103e52:	73 cc                	jae    80103e20 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e54:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e58:	75 ee                	jne    80103e48 <exit+0xe8>
80103e5a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e5d:	75 e9                	jne    80103e48 <exit+0xe8>
      p->state = RUNNABLE;
80103e5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e66:	eb e0                	jmp    80103e48 <exit+0xe8>
  curproc->state = ZOMBIE;
80103e68:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e6f:	e8 2c fe ff ff       	call   80103ca0 <sched>
  panic("zombie exit");
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	68 93 86 10 80       	push   $0x80108693
80103e7c:	e8 0f c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e81:	83 ec 0c             	sub    $0xc,%esp
80103e84:	68 86 86 10 80       	push   $0x80108686
80103e89:	e8 02 c5 ff ff       	call   80100390 <panic>
80103e8e:	66 90                	xchg   %ax,%ax

80103e90 <yield>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e97:	68 60 0f 13 80       	push   $0x80130f60
80103e9c:	e8 af 12 00 00       	call   80105150 <acquire>
  pushcli();
80103ea1:	e8 da 11 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103ea6:	e8 f5 f9 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103eab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eb1:	e8 0a 12 00 00       	call   801050c0 <popcli>
  myproc()->state = RUNNABLE;
80103eb6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ebd:	e8 de fd ff ff       	call   80103ca0 <sched>
  release(&ptable.lock);
80103ec2:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103ec9:	e8 42 13 00 00       	call   80105210 <release>
}
80103ece:	83 c4 10             	add    $0x10,%esp
80103ed1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed4:	c9                   	leave  
80103ed5:	c3                   	ret    
80103ed6:	8d 76 00             	lea    0x0(%esi),%esi
80103ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ee0 <sleep>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103eec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103eef:	e8 8c 11 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103ef4:	e8 a7 f9 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103ef9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eff:	e8 bc 11 00 00       	call   801050c0 <popcli>
  if(p == 0)
80103f04:	85 db                	test   %ebx,%ebx
80103f06:	0f 84 87 00 00 00    	je     80103f93 <sleep+0xb3>
  if(lk == 0)
80103f0c:	85 f6                	test   %esi,%esi
80103f0e:	74 76                	je     80103f86 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f10:	81 fe 60 0f 13 80    	cmp    $0x80130f60,%esi
80103f16:	74 50                	je     80103f68 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f18:	83 ec 0c             	sub    $0xc,%esp
80103f1b:	68 60 0f 13 80       	push   $0x80130f60
80103f20:	e8 2b 12 00 00       	call   80105150 <acquire>
    release(lk);
80103f25:	89 34 24             	mov    %esi,(%esp)
80103f28:	e8 e3 12 00 00       	call   80105210 <release>
  p->chan = chan;
80103f2d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f30:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f37:	e8 64 fd ff ff       	call   80103ca0 <sched>
  p->chan = 0;
80103f3c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f43:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
80103f4a:	e8 c1 12 00 00       	call   80105210 <release>
    acquire(lk);
80103f4f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f52:	83 c4 10             	add    $0x10,%esp
}
80103f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f58:	5b                   	pop    %ebx
80103f59:	5e                   	pop    %esi
80103f5a:	5f                   	pop    %edi
80103f5b:	5d                   	pop    %ebp
    acquire(lk);
80103f5c:	e9 ef 11 00 00       	jmp    80105150 <acquire>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f68:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f6b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f72:	e8 29 fd ff ff       	call   80103ca0 <sched>
  p->chan = 0;
80103f77:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f81:	5b                   	pop    %ebx
80103f82:	5e                   	pop    %esi
80103f83:	5f                   	pop    %edi
80103f84:	5d                   	pop    %ebp
80103f85:	c3                   	ret    
    panic("sleep without lk");
80103f86:	83 ec 0c             	sub    $0xc,%esp
80103f89:	68 a5 86 10 80       	push   $0x801086a5
80103f8e:	e8 fd c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	68 9f 86 10 80       	push   $0x8010869f
80103f9b:	e8 f0 c3 ff ff       	call   80100390 <panic>

80103fa0 <wait>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
  pushcli();
80103fa5:	e8 d6 10 00 00       	call   80105080 <pushcli>
  c = mycpu();
80103faa:	e8 f1 f8 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103faf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fb5:	e8 06 11 00 00       	call   801050c0 <popcli>
  acquire(&ptable.lock);
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 60 0f 13 80       	push   $0x80130f60
80103fc2:	e8 89 11 00 00       	call   80105150 <acquire>
80103fc7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcc:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
80103fd1:	eb 13                	jmp    80103fe6 <wait+0x46>
80103fd3:	90                   	nop
80103fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd8:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103fde:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
80103fe4:	73 1e                	jae    80104004 <wait+0x64>
      if(p->parent != curproc)
80103fe6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fe9:	75 ed                	jne    80103fd8 <wait+0x38>
      if(p->state == ZOMBIE){
80103feb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fef:	74 37                	je     80104028 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff1:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80103ff7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffc:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
80104002:	72 e2                	jb     80103fe6 <wait+0x46>
    if(!havekids || curproc->killed){
80104004:	85 c0                	test   %eax,%eax
80104006:	74 76                	je     8010407e <wait+0xde>
80104008:	8b 46 24             	mov    0x24(%esi),%eax
8010400b:	85 c0                	test   %eax,%eax
8010400d:	75 6f                	jne    8010407e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010400f:	83 ec 08             	sub    $0x8,%esp
80104012:	68 60 0f 13 80       	push   $0x80130f60
80104017:	56                   	push   %esi
80104018:	e8 c3 fe ff ff       	call   80103ee0 <sleep>
    havekids = 0;
8010401d:	83 c4 10             	add    $0x10,%esp
80104020:	eb a8                	jmp    80103fca <wait+0x2a>
80104022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010402e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104031:	e8 ea e2 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80104036:	5a                   	pop    %edx
80104037:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010403a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104041:	e8 2a 3d 00 00       	call   80107d70 <freevm>
        release(&ptable.lock);
80104046:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
        p->pid = 0;
8010404d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104054:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010405b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010405f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104066:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010406d:	e8 9e 11 00 00       	call   80105210 <release>
        return pid;
80104072:	83 c4 10             	add    $0x10,%esp
}
80104075:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104078:	89 f0                	mov    %esi,%eax
8010407a:	5b                   	pop    %ebx
8010407b:	5e                   	pop    %esi
8010407c:	5d                   	pop    %ebp
8010407d:	c3                   	ret    
      release(&ptable.lock);
8010407e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104081:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104086:	68 60 0f 13 80       	push   $0x80130f60
8010408b:	e8 80 11 00 00       	call   80105210 <release>
      return -1;
80104090:	83 c4 10             	add    $0x10,%esp
80104093:	eb e0                	jmp    80104075 <wait+0xd5>
80104095:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040aa:	68 60 0f 13 80       	push   $0x80130f60
801040af:	e8 9c 10 00 00       	call   80105150 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b7:	b8 94 0f 13 80       	mov    $0x80130f94,%eax
801040bc:	eb 0e                	jmp    801040cc <wakeup+0x2c>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	05 88 00 00 00       	add    $0x88,%eax
801040c5:	3d 94 31 13 80       	cmp    $0x80133194,%eax
801040ca:	73 1e                	jae    801040ea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801040cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040d0:	75 ee                	jne    801040c0 <wakeup+0x20>
801040d2:	3b 58 20             	cmp    0x20(%eax),%ebx
801040d5:	75 e9                	jne    801040c0 <wakeup+0x20>
      p->state = RUNNABLE;
801040d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040de:	05 88 00 00 00       	add    $0x88,%eax
801040e3:	3d 94 31 13 80       	cmp    $0x80133194,%eax
801040e8:	72 e2                	jb     801040cc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801040ea:	c7 45 08 60 0f 13 80 	movl   $0x80130f60,0x8(%ebp)
}
801040f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f4:	c9                   	leave  
  release(&ptable.lock);
801040f5:	e9 16 11 00 00       	jmp    80105210 <release>
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104100 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010410a:	68 60 0f 13 80       	push   $0x80130f60
8010410f:	e8 3c 10 00 00       	call   80105150 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104117:	b8 94 0f 13 80       	mov    $0x80130f94,%eax
8010411c:	eb 0e                	jmp    8010412c <kill+0x2c>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	05 88 00 00 00       	add    $0x88,%eax
80104125:	3d 94 31 13 80       	cmp    $0x80133194,%eax
8010412a:	73 34                	jae    80104160 <kill+0x60>
    if(p->pid == pid){
8010412c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010412f:	75 ef                	jne    80104120 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104131:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104135:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010413c:	75 07                	jne    80104145 <kill+0x45>
        p->state = RUNNABLE;
8010413e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104145:	83 ec 0c             	sub    $0xc,%esp
80104148:	68 60 0f 13 80       	push   $0x80130f60
8010414d:	e8 be 10 00 00       	call   80105210 <release>
      return 0;
80104152:	83 c4 10             	add    $0x10,%esp
80104155:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010415a:	c9                   	leave  
8010415b:	c3                   	ret    
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104160:	83 ec 0c             	sub    $0xc,%esp
80104163:	68 60 0f 13 80       	push   $0x80130f60
80104168:	e8 a3 10 00 00       	call   80105210 <release>
  return -1;
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104178:	c9                   	leave  
80104179:	c3                   	ret    
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104180 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104189:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
{
8010418e:	83 ec 3c             	sub    $0x3c,%esp
80104191:	eb 27                	jmp    801041ba <procdump+0x3a>
80104193:	90                   	nop
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 07 87 10 80       	push   $0x80108707
801041a0:	e8 bb c4 ff ff       	call   80100660 <cprintf>
801041a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801041ae:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
801041b4:	0f 83 86 00 00 00    	jae    80104240 <procdump+0xc0>
    if(p->state == UNUSED)
801041ba:	8b 43 0c             	mov    0xc(%ebx),%eax
801041bd:	85 c0                	test   %eax,%eax
801041bf:	74 e7                	je     801041a8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041c1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801041c4:	ba b6 86 10 80       	mov    $0x801086b6,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041c9:	77 11                	ja     801041dc <procdump+0x5c>
801041cb:	8b 14 85 34 88 10 80 	mov    -0x7fef77cc(,%eax,4),%edx
      state = "???";
801041d2:	b8 b6 86 10 80       	mov    $0x801086b6,%eax
801041d7:	85 d2                	test   %edx,%edx
801041d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041df:	50                   	push   %eax
801041e0:	52                   	push   %edx
801041e1:	ff 73 10             	pushl  0x10(%ebx)
801041e4:	68 ba 86 10 80       	push   $0x801086ba
801041e9:	e8 72 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801041ee:	83 c4 10             	add    $0x10,%esp
801041f1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801041f5:	75 a1                	jne    80104198 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041f7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041fa:	83 ec 08             	sub    $0x8,%esp
801041fd:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104200:	50                   	push   %eax
80104201:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104204:	8b 40 0c             	mov    0xc(%eax),%eax
80104207:	83 c0 08             	add    $0x8,%eax
8010420a:	50                   	push   %eax
8010420b:	e8 20 0e 00 00       	call   80105030 <getcallerpcs>
80104210:	83 c4 10             	add    $0x10,%esp
80104213:	90                   	nop
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104218:	8b 17                	mov    (%edi),%edx
8010421a:	85 d2                	test   %edx,%edx
8010421c:	0f 84 76 ff ff ff    	je     80104198 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104222:	83 ec 08             	sub    $0x8,%esp
80104225:	83 c7 04             	add    $0x4,%edi
80104228:	52                   	push   %edx
80104229:	68 e1 80 10 80       	push   $0x801080e1
8010422e:	e8 2d c4 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104233:	83 c4 10             	add    $0x10,%esp
80104236:	39 fe                	cmp    %edi,%esi
80104238:	75 de                	jne    80104218 <procdump+0x98>
8010423a:	e9 59 ff ff ff       	jmp    80104198 <procdump+0x18>
8010423f:	90                   	nop
  }
}
80104240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104243:	5b                   	pop    %ebx
80104244:	5e                   	pop    %esi
80104245:	5f                   	pop    %edi
80104246:	5d                   	pop    %ebp
80104247:	c3                   	ret    
80104248:	90                   	nop
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <halt>:

void
halt(void)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	83 ec 14             	sub    $0x14,%esp
  cprintf("in halt functions: ");
80104256:	68 c3 86 10 80       	push   $0x801086c3
8010425b:	e8 00 c4 ff ff       	call   80100660 <cprintf>

}
80104260:	83 c4 10             	add    $0x10,%esp
80104263:	c9                   	leave  
80104264:	c3                   	ret    
80104265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <toggle>:

int
toggle(void)
{
  if (trace == 0)
80104270:	a1 64 ba 10 80       	mov    0x8010ba64,%eax
{
80104275:	55                   	push   %ebp
80104276:	89 e5                	mov    %esp,%ebp
  if (trace == 0)
80104278:	85 c0                	test   %eax,%eax
8010427a:	74 3c                	je     801042b8 <toggle+0x48>
    trace = 1;
  else
  {
    trace = 0;
    for(int i=0;i<num_syscall;i++)
8010427c:	8b 15 00 b4 10 80    	mov    0x8010b400,%edx
    trace = 0;
80104282:	c7 05 64 ba 10 80 00 	movl   $0x0,0x8010ba64
80104289:	00 00 00 
    for(int i=0;i<num_syscall;i++)
8010428c:	85 d2                	test   %edx,%edx
8010428e:	7e 1d                	jle    801042ad <toggle+0x3d>
80104290:	8d 14 95 e0 b9 10 80 	lea    -0x7fef4620(,%edx,4),%edx
80104297:	b8 e0 b9 10 80       	mov    $0x8010b9e0,%eax
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      counter[i] = 0;
801042a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801042a6:	83 c0 04             	add    $0x4,%eax
    for(int i=0;i<num_syscall;i++)
801042a9:	39 d0                	cmp    %edx,%eax
801042ab:	75 f3                	jne    801042a0 <toggle+0x30>
  }
  // cprintf("trace = %d\n",trace);
  return 0;
}
801042ad:	31 c0                	xor    %eax,%eax
801042af:	5d                   	pop    %ebp
801042b0:	c3                   	ret    
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042b8:	31 c0                	xor    %eax,%eax
    trace = 1;
801042ba:	c7 05 64 ba 10 80 01 	movl   $0x1,0x8010ba64
801042c1:	00 00 00 
}
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
801042c6:	8d 76 00             	lea    0x0(%esi),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042d0 <print_count>:

int 
print_count(void)
{
  for(int i=0;i<num_syscall;i++)
801042d0:	a1 00 b4 10 80       	mov    0x8010b400,%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	7e 57                	jle    80104330 <print_count+0x60>
{
801042d9:	55                   	push   %ebp
801042da:	89 e5                	mov    %esp,%ebp
801042dc:	53                   	push   %ebx
  for(int i=0;i<num_syscall;i++)
801042dd:	31 db                	xor    %ebx,%ebx
{
801042df:	83 ec 04             	sub    $0x4,%esp
801042e2:	eb 0f                	jmp    801042f3 <print_count+0x23>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i=0;i<num_syscall;i++)
801042e8:	83 c3 01             	add    $0x1,%ebx
801042eb:	39 1d 00 b4 10 80    	cmp    %ebx,0x8010b400
801042f1:	7e 30                	jle    80104323 <print_count+0x53>
  {
    if (counter[i]!=0)
801042f3:	8b 04 9d e0 b9 10 80 	mov    -0x7fef4620(,%ebx,4),%eax
801042fa:	85 c0                	test   %eax,%eax
801042fc:	74 ea                	je     801042e8 <print_count+0x18>
      cprintf("%s %d\n", syscall_arr[i], counter[i]);
801042fe:	83 ec 04             	sub    $0x4,%esp
80104301:	50                   	push   %eax
80104302:	6b c3 1e             	imul   $0x1e,%ebx,%eax
  for(int i=0;i<num_syscall;i++)
80104305:	83 c3 01             	add    $0x1,%ebx
      cprintf("%s %d\n", syscall_arr[i], counter[i]);
80104308:	05 20 b0 10 80       	add    $0x8010b020,%eax
8010430d:	50                   	push   %eax
8010430e:	68 d7 86 10 80       	push   $0x801086d7
80104313:	e8 48 c3 ff ff       	call   80100660 <cprintf>
80104318:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<num_syscall;i++)
8010431b:	39 1d 00 b4 10 80    	cmp    %ebx,0x8010b400
80104321:	7f d0                	jg     801042f3 <print_count+0x23>
  }
  // cprintf("print_count completed\n");
  return 0;
}
80104323:	31 c0                	xor    %eax,%eax
80104325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104328:	c9                   	leave  
80104329:	c3                   	ret    
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104330:	31 c0                	xor    %eax,%eax
80104332:	c3                   	ret    
80104333:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104340 <ps>:

int
ps(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
      if (p->state == RUNNING)
        safestrcpy(m, "RUNNING", sizeof(m));
      else if (p->state == RUNNABLE)
        safestrcpy(m, "RUNNABLE", sizeof(m));
      else if (p->state == SLEEPING)
        safestrcpy(m, "SLEEPING", sizeof(m));
80104345:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104348:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
{
8010434d:	83 ec 10             	sub    $0x10,%esp
80104350:	eb 35                	jmp    80104387 <ps+0x47>
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      else if (p->state == RUNNABLE)
80104358:	83 f8 03             	cmp    $0x3,%eax
8010435b:	74 6b                	je     801043c8 <ps+0x88>
      else if (p->state == SLEEPING)
8010435d:	83 f8 02             	cmp    $0x2,%eax
80104360:	74 7e                	je     801043e0 <ps+0xa0>
      // cprintf("pid:%d name:%s state:%s\n",p->pid,p->name,m);
      cprintf("pid:%d name:%s \n",p->pid,p->name);
80104362:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104365:	83 ec 04             	sub    $0x4,%esp
80104368:	50                   	push   %eax
80104369:	ff 73 10             	pushl  0x10(%ebx)
8010436c:	68 f8 86 10 80       	push   $0x801086f8
80104371:	e8 ea c2 ff ff       	call   80100660 <cprintf>
80104376:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104379:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010437f:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
80104385:	73 79                	jae    80104400 <ps+0xc0>
    if(p->state != UNUSED)
80104387:	8b 43 0c             	mov    0xc(%ebx),%eax
8010438a:	85 c0                	test   %eax,%eax
8010438c:	74 eb                	je     80104379 <ps+0x39>
      if (p->state == RUNNING)
8010438e:	83 f8 04             	cmp    $0x4,%eax
      char m[16] = "0";
80104391:	c7 45 e8 30 00 00 00 	movl   $0x30,-0x18(%ebp)
80104398:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010439f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801043a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      if (p->state == RUNNING)
801043ad:	75 a9                	jne    80104358 <ps+0x18>
        safestrcpy(m, "RUNNING", sizeof(m));
801043af:	83 ec 04             	sub    $0x4,%esp
801043b2:	6a 10                	push   $0x10
801043b4:	68 de 86 10 80       	push   $0x801086de
801043b9:	56                   	push   %esi
801043ba:	e8 81 10 00 00       	call   80105440 <safestrcpy>
801043bf:	83 c4 10             	add    $0x10,%esp
801043c2:	eb 9e                	jmp    80104362 <ps+0x22>
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        safestrcpy(m, "RUNNABLE", sizeof(m));
801043c8:	83 ec 04             	sub    $0x4,%esp
801043cb:	6a 10                	push   $0x10
801043cd:	68 e6 86 10 80       	push   $0x801086e6
801043d2:	56                   	push   %esi
801043d3:	e8 68 10 00 00       	call   80105440 <safestrcpy>
801043d8:	83 c4 10             	add    $0x10,%esp
801043db:	eb 85                	jmp    80104362 <ps+0x22>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
        safestrcpy(m, "SLEEPING", sizeof(m));
801043e0:	83 ec 04             	sub    $0x4,%esp
801043e3:	6a 10                	push   $0x10
801043e5:	68 ef 86 10 80       	push   $0x801086ef
801043ea:	56                   	push   %esi
801043eb:	e8 50 10 00 00       	call   80105440 <safestrcpy>
801043f0:	83 c4 10             	add    $0x10,%esp
801043f3:	e9 6a ff ff ff       	jmp    80104362 <ps+0x22>
801043f8:	90                   	nop
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      //       cprintf("belongs to a container\n");
      //   }
      // }
    }
  return 0;
}
80104400:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104403:	31 c0                	xor    %eax,%eax
80104405:	5b                   	pop    %ebx
80104406:	5e                   	pop    %esi
80104407:	5d                   	pop    %ebp
80104408:	c3                   	ret    
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <send>:

int
send(int send_pid, int rec_pid, char* msg)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	53                   	push   %ebx
  struct proc *p = &ptable.proc[rec_pid-1];
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104416:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
{
8010441b:	83 ec 2c             	sub    $0x2c,%esp
8010441e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104421:	8b 75 10             	mov    0x10(%ebp),%esi
80104424:	eb 18                	jmp    8010443e <send+0x2e>
80104426:	8d 76 00             	lea    0x0(%esi),%esi
80104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104430:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104436:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
8010443c:	73 05                	jae    80104443 <send+0x33>
    if(p->pid == rec_pid)
8010443e:	39 43 10             	cmp    %eax,0x10(%ebx)
80104441:	75 ed                	jne    80104430 <send+0x20>
      break;
  
  if (p->state == SLEEPING)
80104443:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104447:	0f 84 c3 00 00 00    	je     80104510 <send+0x100>
    release(&msg_queue[p->pid-1].lock);
    
  }
  else 
  {
    acquire(&msg_queue[p->pid-1].lock);
8010444d:	8b 43 10             	mov    0x10(%ebx),%eax
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	83 e8 01             	sub    $0x1,%eax
80104456:	69 c0 84 06 00 00    	imul   $0x684,%eax,%eax
8010445c:	05 e0 51 11 80       	add    $0x801151e0,%eax
80104461:	50                   	push   %eax
80104462:	e8 e9 0c 00 00       	call   80105150 <acquire>
80104467:	8d 4d e0             	lea    -0x20(%ebp),%ecx
8010446a:	83 c4 10             	add    $0x10,%esp

    char in_msg[8];
    for(int i=0;i<8;i++)
8010446d:	31 c0                	xor    %eax,%eax
8010446f:	90                   	nop
    {
      in_msg[i] = *msg;
80104470:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104474:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    for(int i=0;i<8;i++)
80104477:	83 c0 01             	add    $0x1,%eax
8010447a:	83 f8 08             	cmp    $0x8,%eax
8010447d:	75 f1                	jne    80104470 <send+0x60>
      msg++;
    }
    if (enqueue(&msg_queue[p->pid-1], in_msg) < 0)
8010447f:	8b 43 10             	mov    0x10(%ebx),%eax
80104482:	83 e8 01             	sub    $0x1,%eax
    if (q->size == MSGBUFFSIZE) 
80104485:	69 f8 84 06 00 00    	imul   $0x684,%eax,%edi
    if (enqueue(&msg_queue[p->pid-1], in_msg) < 0)
8010448b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (q->size == MSGBUFFSIZE) 
8010448e:	8d b7 e0 51 11 80    	lea    -0x7feeae20(%edi),%esi
80104494:	8b 46 3c             	mov    0x3c(%esi),%eax
80104497:	3d c8 00 00 00       	cmp    $0xc8,%eax
8010449c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010449f:	0f 84 13 01 00 00    	je     801045b8 <send+0x1a8>
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
801044a5:	8b 46 38             	mov    0x38(%esi),%eax
801044a8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801044ad:	8d 58 01             	lea    0x1(%eax),%ebx
801044b0:	89 d8                	mov    %ebx,%eax
801044b2:	f7 ea                	imul   %edx
801044b4:	89 d8                	mov    %ebx,%eax
801044b6:	c1 f8 1f             	sar    $0x1f,%eax
801044b9:	c1 fa 06             	sar    $0x6,%edx
801044bc:	29 c2                	sub    %eax,%edx
    for(int i=0;i<8;i++)
801044be:	31 c0                	xor    %eax,%eax
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
801044c0:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
801044c6:	29 d3                	sub    %edx,%ebx
801044c8:	8d 14 df             	lea    (%edi,%ebx,8),%edx
801044cb:	89 5e 38             	mov    %ebx,0x38(%esi)
801044ce:	66 90                	xchg   %ax,%ax
      q->array[q->rear][i] = *item; 
801044d0:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
801044d4:	88 9c 02 24 52 11 80 	mov    %bl,-0x7feeaddc(%edx,%eax,1)
    for(int i=0;i<8;i++)
801044db:	83 c0 01             	add    $0x1,%eax
801044de:	83 f8 08             	cmp    $0x8,%eax
801044e1:	75 ed                	jne    801044d0 <send+0xc0>
    q->size = q->size + 1; 
801044e3:	69 45 d4 84 06 00 00 	imul   $0x684,-0x2c(%ebp),%eax
801044ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
    {
      return -1;
    }

    
    release(&msg_queue[p->pid-1].lock);
801044ed:	83 ec 0c             	sub    $0xc,%esp
801044f0:	56                   	push   %esi
    q->size = q->size + 1; 
801044f1:	83 c2 01             	add    $0x1,%edx
801044f4:	89 90 1c 52 11 80    	mov    %edx,-0x7feeade4(%eax)
    release(&msg_queue[p->pid-1].lock);
801044fa:	e8 11 0d 00 00       	call   80105210 <release>
801044ff:	83 c4 10             	add    $0x10,%esp

  }

  
  return 0;
80104502:	31 c0                	xor    %eax,%eax
}
80104504:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104507:	5b                   	pop    %ebx
80104508:	5e                   	pop    %esi
80104509:	5f                   	pop    %edi
8010450a:	5d                   	pop    %ebp
8010450b:	c3                   	ret    
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(p);
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	53                   	push   %ebx
80104514:	e8 87 fb ff ff       	call   801040a0 <wakeup>
    acquire(&msg_queue[p->pid-1].lock);
80104519:	8b 43 10             	mov    0x10(%ebx),%eax
8010451c:	83 e8 01             	sub    $0x1,%eax
8010451f:	69 c0 84 06 00 00    	imul   $0x684,%eax,%eax
80104525:	05 e0 51 11 80       	add    $0x801151e0,%eax
8010452a:	89 04 24             	mov    %eax,(%esp)
8010452d:	e8 1e 0c 00 00       	call   80105150 <acquire>
80104532:	8d 4d e0             	lea    -0x20(%ebp),%ecx
80104535:	83 c4 10             	add    $0x10,%esp
    for(int i=0;i<8;i++)
80104538:	31 d2                	xor    %edx,%edx
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      in_msg[i] = *msg;
80104540:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80104544:	88 04 11             	mov    %al,(%ecx,%edx,1)
    for(int i=0;i<8;i++)
80104547:	83 c2 01             	add    $0x1,%edx
8010454a:	83 fa 08             	cmp    $0x8,%edx
8010454d:	75 f1                	jne    80104540 <send+0x130>
    if (enqueue(&msg_queue[p->pid-1], in_msg) < 0)
8010454f:	8b 43 10             	mov    0x10(%ebx),%eax
80104552:	83 e8 01             	sub    $0x1,%eax
    if (q->size == MSGBUFFSIZE) 
80104555:	69 f8 84 06 00 00    	imul   $0x684,%eax,%edi
    if (enqueue(&msg_queue[p->pid-1], in_msg) < 0)
8010455b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (q->size == MSGBUFFSIZE) 
8010455e:	8d b7 e0 51 11 80    	lea    -0x7feeae20(%edi),%esi
80104564:	8b 46 3c             	mov    0x3c(%esi),%eax
80104567:	3d c8 00 00 00       	cmp    $0xc8,%eax
8010456c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010456f:	74 47                	je     801045b8 <send+0x1a8>
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
80104571:	8b 46 38             	mov    0x38(%esi),%eax
80104574:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80104579:	8d 58 01             	lea    0x1(%eax),%ebx
8010457c:	89 d8                	mov    %ebx,%eax
8010457e:	f7 ea                	imul   %edx
80104580:	89 d8                	mov    %ebx,%eax
80104582:	c1 f8 1f             	sar    $0x1f,%eax
80104585:	c1 fa 06             	sar    $0x6,%edx
80104588:	29 c2                	sub    %eax,%edx
    for(int i=0;i<8;i++)
8010458a:	31 c0                	xor    %eax,%eax
    q->rear = (q->rear + 1)%MSGBUFFSIZE; 
8010458c:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
80104592:	29 d3                	sub    %edx,%ebx
80104594:	8d 14 df             	lea    (%edi,%ebx,8),%edx
80104597:	89 5e 38             	mov    %ebx,0x38(%esi)
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      q->array[q->rear][i] = *item; 
801045a0:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
801045a4:	88 9c 02 24 52 11 80 	mov    %bl,-0x7feeaddc(%edx,%eax,1)
    for(int i=0;i<8;i++)
801045ab:	83 c0 01             	add    $0x1,%eax
801045ae:	83 f8 08             	cmp    $0x8,%eax
801045b1:	75 ed                	jne    801045a0 <send+0x190>
801045b3:	e9 2b ff ff ff       	jmp    801044e3 <send+0xd3>
      return -1;
801045b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045bd:	e9 42 ff ff ff       	jmp    80104504 <send+0xf4>
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <recv>:

int
recv(char* msg)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045d9:	e8 a2 0a 00 00       	call   80105080 <pushcli>
  c = mycpu();
801045de:	e8 bd f2 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801045e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045e9:	e8 d2 0a 00 00       	call   801050c0 <popcli>
  struct proc *curproc = myproc();
  int rec_pid = curproc->pid;
  
  if (msg_queue[rec_pid-1].size == 0)
801045ee:	8b 46 10             	mov    0x10(%esi),%eax
801045f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801045f4:	69 c3 84 06 00 00    	imul   $0x684,%ebx,%eax
801045fa:	8b 88 1c 52 11 80    	mov    -0x7feeade4(%eax),%ecx
80104600:	85 c9                	test   %ecx,%ecx
80104602:	0f 84 80 00 00 00    	je     80104688 <recv+0xb8>
80104608:	69 c3 84 06 00 00    	imul   $0x684,%ebx,%eax
    release(&ptable.lock);

  } 
  char* m = front(&msg_queue[rec_pid-1]);
  
  acquire(&msg_queue[rec_pid-1].lock);
8010460e:	83 ec 0c             	sub    $0xc,%esp
    return q->array[q->front+1]; 
80104611:	8d 98 e0 51 11 80    	lea    -0x7feeae20(%eax),%ebx
80104617:	8b 90 14 52 11 80    	mov    -0x7feeadec(%eax),%edx
  acquire(&msg_queue[rec_pid-1].lock);
8010461d:	53                   	push   %ebx
    return q->array[q->front+1]; 
8010461e:	8d b4 d0 2c 52 11 80 	lea    -0x7feeadd4(%eax,%edx,8),%esi
  acquire(&msg_queue[rec_pid-1].lock);
80104625:	e8 26 0b 00 00       	call   80105150 <acquire>
{  return (q->size == 0); } 
8010462a:	8b 7b 3c             	mov    0x3c(%ebx),%edi
    if (isEmpty(q)) 
8010462d:	83 c4 10             	add    $0x10,%esp
80104630:	85 ff                	test   %edi,%edi
80104632:	0f 84 88 00 00 00    	je     801046c0 <recv+0xf0>
    q->front = (q->front + 1)%MSGBUFFSIZE; 
80104638:	8b 43 34             	mov    0x34(%ebx),%eax
8010463b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx

  if (dequeue(&msg_queue[rec_pid-1]) < 0)
    return -1;
  
  strncpy(msg,m,8);
80104640:	83 ec 04             	sub    $0x4,%esp
    q->size = q->size - 1; 
80104643:	83 ef 01             	sub    $0x1,%edi
80104646:	89 7b 3c             	mov    %edi,0x3c(%ebx)
    q->front = (q->front + 1)%MSGBUFFSIZE; 
80104649:	8d 48 01             	lea    0x1(%eax),%ecx
8010464c:	89 c8                	mov    %ecx,%eax
8010464e:	f7 ea                	imul   %edx
80104650:	89 c8                	mov    %ecx,%eax
80104652:	c1 f8 1f             	sar    $0x1f,%eax
80104655:	c1 fa 06             	sar    $0x6,%edx
80104658:	29 c2                	sub    %eax,%edx
8010465a:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
80104660:	29 d1                	sub    %edx,%ecx
80104662:	89 4b 34             	mov    %ecx,0x34(%ebx)
  strncpy(msg,m,8);
80104665:	6a 08                	push   $0x8
80104667:	56                   	push   %esi
80104668:	ff 75 08             	pushl  0x8(%ebp)
8010466b:	e8 70 0d 00 00       	call   801053e0 <strncpy>
  
  release(&msg_queue[rec_pid-1].lock);
80104670:	89 1c 24             	mov    %ebx,(%esp)
80104673:	e8 98 0b 00 00       	call   80105210 <release>

  
  return 0;
80104678:	83 c4 10             	add    $0x10,%esp
8010467b:	31 c0                	xor    %eax,%eax
}
8010467d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104680:	5b                   	pop    %ebx
80104681:	5e                   	pop    %esi
80104682:	5f                   	pop    %edi
80104683:	5d                   	pop    %ebp
80104684:	c3                   	ret    
80104685:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 60 0f 13 80       	push   $0x80130f60
80104690:	e8 bb 0a 00 00       	call   80105150 <acquire>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104695:	58                   	pop    %eax
80104696:	5a                   	pop    %edx
80104697:	68 60 0f 13 80       	push   $0x80130f60
8010469c:	56                   	push   %esi
8010469d:	e8 3e f8 ff ff       	call   80103ee0 <sleep>
    release(&ptable.lock);
801046a2:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
801046a9:	e8 62 0b 00 00       	call   80105210 <release>
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	e9 52 ff ff ff       	jmp    80104608 <recv+0x38>
801046b6:	8d 76 00             	lea    0x0(%esi),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801046c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c5:	eb b6                	jmp    8010467d <recv+0xad>
801046c7:	89 f6                	mov    %esi,%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <send_multi>:

int
send_multi(int send_pid, int* rec_pid, char* msg, int len)
{
801046d0:	55                   	push   %ebp
  // cprintf("in send_multi function\n");
  // cprintf("msg: %s\n",input_msg);
  // cprintf("send pid: %d\n",send_pid);
  // cprintf("len: %d\n",len);

  for(int i=0;i<8;i++)
801046d1:	31 c0                	xor    %eax,%eax
{
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	57                   	push   %edi
801046d6:	56                   	push   %esi
801046d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046da:	53                   	push   %ebx
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    mean_buffer[i] = *msg;
801046e0:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
  for(int i=0;i<8;i++)
801046e4:	83 c0 01             	add    $0x1,%eax
    mean_buffer[i] = *msg;
801046e7:	88 90 df f2 12 80    	mov    %dl,-0x7fed0d21(%eax)
  for(int i=0;i<8;i++)
801046ed:	83 f8 08             	cmp    $0x8,%eax
801046f0:	75 ee                	jne    801046e0 <send_multi+0x10>
  msg = msg - 8;
  // cprintf("mean_buffer: %s\n",mean_buffer);
  // cprintf("msg: %s\n",msg);

  // cprintf("rec_pid: \n");
  for(int i=0;i<len;i++)
801046f2:	8b 45 14             	mov    0x14(%ebp),%eax
801046f5:	85 c0                	test   %eax,%eax
801046f7:	7e 4e                	jle    80104747 <send_multi+0x77>
  {
    // cprintf("%d   ",rec_pid[i]);
    for(int j=0;j<map_len;j++)
801046f9:	8b 1d cc b9 10 80    	mov    0x8010b9cc,%ebx
    {
      if (map[j].b == rec_pid[i])
801046ff:	8b 3d 14 42 11 80    	mov    0x80114214,%edi
  for(int i=0;i<len;i++)
80104705:	31 f6                	xor    %esi,%esi
80104707:	89 f6                	mov    %esi,%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(int j=0;j<map_len;j++)
80104710:	85 db                	test   %ebx,%ebx
80104712:	7e 2b                	jle    8010473f <send_multi+0x6f>
      if (map[j].b == rec_pid[i])
80104714:	8b 45 0c             	mov    0xc(%ebp),%eax
80104717:	ba 50 42 11 80       	mov    $0x80114250,%edx
8010471c:	8b 0c b0             	mov    (%eax,%esi,4),%ecx
    for(int j=0;j<map_len;j++)
8010471f:	31 c0                	xor    %eax,%eax
      if (map[j].b == rec_pid[i])
80104721:	39 cf                	cmp    %ecx,%edi
80104723:	75 13                	jne    80104738 <send_multi+0x68>
80104725:	eb 27                	jmp    8010474e <send_multi+0x7e>
80104727:	89 f6                	mov    %esi,%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104730:	83 c2 3c             	add    $0x3c,%edx
80104733:	39 4a c4             	cmp    %ecx,-0x3c(%edx)
80104736:	74 18                	je     80104750 <send_multi+0x80>
    for(int j=0;j<map_len;j++)
80104738:	83 c0 01             	add    $0x1,%eax
8010473b:	39 d8                	cmp    %ebx,%eax
8010473d:	75 f1                	jne    80104730 <send_multi+0x60>
  for(int i=0;i<len;i++)
8010473f:	83 c6 01             	add    $0x1,%esi
80104742:	39 75 14             	cmp    %esi,0x14(%ebp)
80104745:	75 c9                	jne    80104710 <send_multi+0x40>
      }
    }
  }
  // cprintf("ending send_multi\n");
  return 0;
}
80104747:	5b                   	pop    %ebx
80104748:	31 c0                	xor    %eax,%eax
8010474a:	5e                   	pop    %esi
8010474b:	5f                   	pop    %edi
8010474c:	5d                   	pop    %ebp
8010474d:	c3                   	ret    
    for(int j=0;j<map_len;j++)
8010474e:	31 c0                	xor    %eax,%eax
        wakeupcustom(map[j].s);
80104750:	6b c0 3c             	imul   $0x3c,%eax,%eax
{
  // cprintf("in wakeupcustom function\n");
  // cprintf("pid: %d\n",p_pid);
  
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104753:	ba 94 0f 13 80       	mov    $0x80130f94,%edx
        wakeupcustom(map[j].s);
80104758:	8b 80 18 42 11 80    	mov    -0x7feebde8(%eax),%eax
8010475e:	eb 0e                	jmp    8010476e <send_multi+0x9e>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104760:	81 c2 88 00 00 00    	add    $0x88,%edx
80104766:	81 fa 94 31 13 80    	cmp    $0x80133194,%edx
8010476c:	73 05                	jae    80104773 <send_multi+0xa3>
    if(p->pid == p_pid)
8010476e:	3b 42 10             	cmp    0x10(%edx),%eax
80104771:	75 ed                	jne    80104760 <send_multi+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104773:	b8 94 0f 13 80       	mov    $0x80130f94,%eax
80104778:	eb 12                	jmp    8010478c <send_multi+0xbc>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104780:	05 88 00 00 00       	add    $0x88,%eax
80104785:	3d 94 31 13 80       	cmp    $0x80133194,%eax
8010478a:	73 b3                	jae    8010473f <send_multi+0x6f>
    if(p->state == SLEEPING && p->chan == chan)
8010478c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104790:	75 ee                	jne    80104780 <send_multi+0xb0>
80104792:	39 50 20             	cmp    %edx,0x20(%eax)
80104795:	75 e9                	jne    80104780 <send_multi+0xb0>
      p->state = RUNNABLE;
80104797:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010479e:	eb e0                	jmp    80104780 <send_multi+0xb0>

801047a0 <store>:
  map[map_len].b = brother_pid;
801047a0:	a1 cc b9 10 80       	mov    0x8010b9cc,%eax
{
801047a5:	55                   	push   %ebp
801047a6:	89 e5                	mov    %esp,%ebp
  map[map_len].b = brother_pid;
801047a8:	6b d0 3c             	imul   $0x3c,%eax,%edx
801047ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  map_len++;
801047ae:	83 c0 01             	add    $0x1,%eax
801047b1:	a3 cc b9 10 80       	mov    %eax,0x8010b9cc
}
801047b6:	31 c0                	xor    %eax,%eax
  map[map_len].b = brother_pid;
801047b8:	89 8a 14 42 11 80    	mov    %ecx,-0x7feebdec(%edx)
  map[map_len].s = sister_pid;
801047be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}
801047c1:	5d                   	pop    %ebp
  map[map_len].s = sister_pid;
801047c2:	89 8a 18 42 11 80    	mov    %ecx,-0x7feebde8(%edx)
}
801047c8:	c3                   	ret    
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047d0 <sleepcustom>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047d4:	bb 94 0f 13 80       	mov    $0x80130f94,%ebx
{
801047d9:	83 ec 04             	sub    $0x4,%esp
801047dc:	8b 45 08             	mov    0x8(%ebp),%eax
801047df:	eb 15                	jmp    801047f6 <sleepcustom+0x26>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047e8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801047ee:	81 fb 94 31 13 80    	cmp    $0x80133194,%ebx
801047f4:	73 05                	jae    801047fb <sleepcustom+0x2b>
    if(p->pid == p_pid)
801047f6:	39 43 10             	cmp    %eax,0x10(%ebx)
801047f9:	75 ed                	jne    801047e8 <sleepcustom+0x18>
  acquire(&ptable.lock);
801047fb:	83 ec 0c             	sub    $0xc,%esp
801047fe:	68 60 0f 13 80       	push   $0x80130f60
80104803:	e8 48 09 00 00       	call   80105150 <acquire>
  sleep(p, &ptable.lock);  //DOC: wait-sleep
80104808:	58                   	pop    %eax
80104809:	5a                   	pop    %edx
8010480a:	68 60 0f 13 80       	push   $0x80130f60
8010480f:	53                   	push   %ebx
80104810:	e8 cb f6 ff ff       	call   80103ee0 <sleep>
  release(&ptable.lock);
80104815:	c7 04 24 60 0f 13 80 	movl   $0x80130f60,(%esp)
8010481c:	e8 ef 09 00 00       	call   80105210 <release>
}
80104821:	31 c0                	xor    %eax,%eax
80104823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104826:	c9                   	leave  
80104827:	c3                   	ret    
80104828:	90                   	nop
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <wakeupcustom>:
{
80104830:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104831:	ba 94 0f 13 80       	mov    $0x80130f94,%edx
{
80104836:	89 e5                	mov    %esp,%ebp
80104838:	8b 45 08             	mov    0x8(%ebp),%eax
8010483b:	eb 11                	jmp    8010484e <wakeupcustom+0x1e>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104840:	81 c2 88 00 00 00    	add    $0x88,%edx
80104846:	81 fa 94 31 13 80    	cmp    $0x80133194,%edx
8010484c:	73 05                	jae    80104853 <wakeupcustom+0x23>
    if(p->pid == p_pid)
8010484e:	39 42 10             	cmp    %eax,0x10(%edx)
80104851:	75 ed                	jne    80104840 <wakeupcustom+0x10>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104853:	b8 94 0f 13 80       	mov    $0x80130f94,%eax
80104858:	eb 12                	jmp    8010486c <wakeupcustom+0x3c>
8010485a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104860:	05 88 00 00 00       	add    $0x88,%eax
80104865:	3d 94 31 13 80       	cmp    $0x80133194,%eax
8010486a:	73 1e                	jae    8010488a <wakeupcustom+0x5a>
    if(p->state == SLEEPING && p->chan == chan)
8010486c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104870:	75 ee                	jne    80104860 <wakeupcustom+0x30>
80104872:	39 50 20             	cmp    %edx,0x20(%eax)
80104875:	75 e9                	jne    80104860 <wakeupcustom+0x30>
      p->state = RUNNABLE;
80104877:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010487e:	05 88 00 00 00       	add    $0x88,%eax
80104883:	3d 94 31 13 80       	cmp    $0x80133194,%eax
80104888:	72 e2                	jb     8010486c <wakeupcustom+0x3c>
      break;

  wakeup1(p);

  return 0;
}
8010488a:	31 c0                	xor    %eax,%eax
8010488c:	5d                   	pop    %ebp
8010488d:	c3                   	ret    
8010488e:	66 90                	xchg   %ax,%ax

80104890 <read_mean>:

int
read_mean(char* mean)
{
80104890:	55                   	push   %ebp
  // cprintf("in read_mean function\n");
  for(int i=0;i<8;i++)
80104891:	31 c0                	xor    %eax,%eax
{
80104893:	89 e5                	mov    %esp,%ebp
80104895:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104898:	90                   	nop
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    *mean = mean_buffer[i];
801048a0:	0f b6 90 e0 f2 12 80 	movzbl -0x7fed0d20(%eax),%edx
801048a7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  for(int i=0;i<8;i++)
801048aa:	83 c0 01             	add    $0x1,%eax
801048ad:	83 f8 08             	cmp    $0x8,%eax
801048b0:	75 ee                	jne    801048a0 <read_mean+0x10>
    mean++;
  }
  mean = mean - 8;
  // cprintf("mean in proc: %s\n",mean);
  return 0;
}
801048b2:	31 c0                	xor    %eax,%eax
801048b4:	5d                   	pop    %ebp
801048b5:	c3                   	ret    
801048b6:	8d 76 00             	lea    0x0(%esi),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <get_proc>:

struct proc 
get_proc(int pid)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	8b 45 08             	mov    0x8(%ebp),%eax
801048c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048cb:	be 94 0f 13 80       	mov    $0x80130f94,%esi
801048d0:	eb 14                	jmp    801048e6 <get_proc+0x26>
801048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d8:	81 c6 88 00 00 00    	add    $0x88,%esi
801048de:	81 fe 94 31 13 80    	cmp    $0x80133194,%esi
801048e4:	73 05                	jae    801048eb <get_proc+0x2b>
    if(p->pid == pid)
801048e6:	39 56 10             	cmp    %edx,0x10(%esi)
801048e9:	75 ed                	jne    801048d8 <get_proc+0x18>
      break;
  return (*p);
801048eb:	b9 22 00 00 00       	mov    $0x22,%ecx
801048f0:	89 c7                	mov    %eax,%edi
801048f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
801048f4:	5e                   	pop    %esi
801048f5:	5f                   	pop    %edi
801048f6:	5d                   	pop    %ebp
801048f7:	c2 04 00             	ret    $0x4
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <init_container>:

void init_container(struct container* c, int t_id)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	8b 45 08             	mov    0x8(%ebp),%eax
  (*c).id = t_id;
80104906:	8b 55 0c             	mov    0xc(%ebp),%edx
  (*c).active = 1;
80104909:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  (*c).id = t_id;
80104910:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<NPROC_CONTAINER;i++)
    (*c).process_active[i] = 0;
80104912:	c7 80 18 01 00 00 00 	movl   $0x0,0x118(%eax)
80104919:	00 00 00 
8010491c:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80104923:	00 00 00 
  for(int i=0;i<MAX_PAGES;i++)
    (*c).page_active[i] = 0;
80104926:	c7 80 44 01 00 00 00 	movl   $0x0,0x144(%eax)
8010492d:	00 00 00 
80104930:	c7 80 48 01 00 00 00 	movl   $0x0,0x148(%eax)
80104937:	00 00 00 
8010493a:	c7 80 4c 01 00 00 00 	movl   $0x0,0x14c(%eax)
80104941:	00 00 00 
80104944:	c7 80 50 01 00 00 00 	movl   $0x0,0x150(%eax)
8010494b:	00 00 00 
8010494e:	c7 80 54 01 00 00 00 	movl   $0x0,0x154(%eax)
80104955:	00 00 00 
80104958:	c7 80 58 01 00 00 00 	movl   $0x0,0x158(%eax)
8010495f:	00 00 00 
80104962:	c7 80 5c 01 00 00 00 	movl   $0x0,0x15c(%eax)
80104969:	00 00 00 
8010496c:	c7 80 60 01 00 00 00 	movl   $0x0,0x160(%eax)
80104973:	00 00 00 
  for(int i=0;i<MAX_FILES;i++)
    (*c).file_active[i] = 0;
80104976:	c7 80 88 01 00 00 00 	movl   $0x0,0x188(%eax)
8010497d:	00 00 00 
80104980:	c7 80 8c 01 00 00 00 	movl   $0x0,0x18c(%eax)
80104987:	00 00 00 
8010498a:	c7 80 90 01 00 00 00 	movl   $0x0,0x190(%eax)
80104991:	00 00 00 
80104994:	c7 80 94 01 00 00 00 	movl   $0x0,0x194(%eax)
8010499b:	00 00 00 
8010499e:	c7 80 98 01 00 00 00 	movl   $0x0,0x198(%eax)
801049a5:	00 00 00 
801049a8:	c7 80 9c 01 00 00 00 	movl   $0x0,0x19c(%eax)
801049af:	00 00 00 
801049b2:	c7 80 a0 01 00 00 00 	movl   $0x0,0x1a0(%eax)
801049b9:	00 00 00 
801049bc:	c7 80 a4 01 00 00 00 	movl   $0x0,0x1a4(%eax)
801049c3:	00 00 00 
  (*c).process_pointer = 0;  
801049c6:	c7 80 20 01 00 00 00 	movl   $0x0,0x120(%eax)
801049cd:	00 00 00 
  (*c).page_pointer = 0;  
801049d0:	c7 80 64 01 00 00 00 	movl   $0x0,0x164(%eax)
801049d7:	00 00 00 
  (*c).file_pointer = 0;  
801049da:	c7 80 a8 01 00 00 00 	movl   $0x0,0x1a8(%eax)
801049e1:	00 00 00 
}
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret    
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <print_c_table>:

void print_c_table()
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	be c4 b9 10 80       	mov    $0x8010b9c4,%esi
801049fa:	bb 00 0c 13 80       	mov    $0x80130c00,%ebx
  cprintf("conatiner_table:\n");
801049ff:	83 ec 0c             	sub    $0xc,%esp
80104a02:	68 09 87 10 80       	push   $0x80108709
80104a07:	e8 54 bc ff ff       	call   80100660 <cprintf>
80104a0c:	83 c4 10             	add    $0x10,%esp
  for (int i=0;i<NCONTAINER;i++)
  {
    cprintf("id: %d active: %d\n",container_table[i].id,c_active[i]);
80104a0f:	83 ec 04             	sub    $0x4,%esp
80104a12:	ff 36                	pushl  (%esi)
80104a14:	ff 33                	pushl  (%ebx)
80104a16:	68 1b 87 10 80       	push   $0x8010871b
80104a1b:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80104a21:	83 c6 04             	add    $0x4,%esi
80104a24:	e8 37 bc ff ff       	call   80100660 <cprintf>
    for (int j=0;j<NPROC_CONTAINER;j++)
      cprintf("\t process_id: %d active bit: %d state: %d c_id: %d\n",container_table[i].process_table[j].pid,
80104a29:	58                   	pop    %eax
80104a2a:	ff b3 dc fe ff ff    	pushl  -0x124(%ebx)
80104a30:	ff b3 68 fe ff ff    	pushl  -0x198(%ebx)
80104a36:	ff b3 6c ff ff ff    	pushl  -0x94(%ebx)
80104a3c:	ff b3 6c fe ff ff    	pushl  -0x194(%ebx)
80104a42:	68 00 88 10 80       	push   $0x80108800
80104a47:	e8 14 bc ff ff       	call   80100660 <cprintf>
80104a4c:	83 c4 14             	add    $0x14,%esp
80104a4f:	ff b3 64 ff ff ff    	pushl  -0x9c(%ebx)
80104a55:	ff b3 f0 fe ff ff    	pushl  -0x110(%ebx)
80104a5b:	ff b3 70 ff ff ff    	pushl  -0x90(%ebx)
80104a61:	ff b3 f4 fe ff ff    	pushl  -0x10c(%ebx)
80104a67:	68 00 88 10 80       	push   $0x80108800
80104a6c:	e8 ef bb ff ff       	call   80100660 <cprintf>
  for (int i=0;i<NCONTAINER;i++)
80104a71:	83 c4 20             	add    $0x20,%esp
80104a74:	81 fb 58 0f 13 80    	cmp    $0x80130f58,%ebx
80104a7a:	75 93                	jne    80104a0f <print_c_table+0x1f>
          container_table[i].process_active[j],container_table[i].process_table[j].state,
          container_table[i].process_table[j].container_id);
  }
}
80104a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a7f:	5b                   	pop    %ebx
80104a80:	5e                   	pop    %esi
80104a81:	5d                   	pop    %ebp
80104a82:	c3                   	ret    
80104a83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <create_container>:

int
create_container()
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	81 ec c8 01 00 00    	sub    $0x1c8,%esp
  cprintf("in create_container\n");
80104a9c:	68 2e 87 10 80       	push   $0x8010872e
80104aa1:	e8 ba bb ff ff       	call   80100660 <cprintf>
  //when the container table is full
  if (c_pointer == -1)
80104aa6:	8b 1d c0 b9 10 80    	mov    0x8010b9c0,%ebx
80104aac:	83 c4 10             	add    $0x10,%esp
80104aaf:	83 fb ff             	cmp    $0xffffffff,%ebx
80104ab2:	0f 84 46 01 00 00    	je     80104bfe <create_container+0x16e>
    return -1;
  }
  c_active[c_pointer] = 1;
  struct container c;
  init_container(&c,c_pointer);
  container_table[c_pointer] = c;
80104ab8:	69 c3 ac 01 00 00    	imul   $0x1ac,%ebx,%eax
    (*c).page_active[i] = 0;
80104abe:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
80104ac5:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
80104acc:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)
80104ad3:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
  container_table[c_pointer] = c;
80104ada:	8d b5 3c fe ff ff    	lea    -0x1c4(%ebp),%esi
    (*c).page_active[i] = 0;
80104ae0:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
80104ae7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  container_table[c_pointer] = c;
80104aee:	b9 6b 00 00 00       	mov    $0x6b,%ecx
80104af3:	05 00 0c 13 80       	add    $0x80130c00,%eax
    (*c).page_active[i] = 0;
80104af8:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
80104aff:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
  container_table[c_pointer] = c;
80104b06:	89 c7                	mov    %eax,%edi
    (*c).file_active[i] = 0;
80104b08:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
80104b0f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
80104b16:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
80104b1d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
80104b24:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80104b2b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80104b32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104b39:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  container_table[c_pointer] = c;
80104b40:	89 9d 3c fe ff ff    	mov    %ebx,-0x1c4(%ebp)
80104b46:	c7 85 40 fe ff ff 01 	movl   $0x1,-0x1c0(%ebp)
80104b4d:	00 00 00 
80104b50:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
80104b57:	00 00 00 
80104b5a:	c7 85 58 ff ff ff 00 	movl   $0x0,-0xa8(%ebp)
80104b61:	00 00 00 
80104b64:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
80104b6b:	00 00 00 
80104b6e:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
80104b75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  c_active[c_pointer] = 1;
80104b7c:	c7 04 9d c4 b9 10 80 	movl   $0x1,-0x7fef463c(,%ebx,4)
80104b83:	01 00 00 00 
  container_table[c_pointer] = c;
80104b87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  int output = c_pointer;
  
  print_c_table();
80104b89:	e8 62 fe ff ff       	call   801049f0 <print_c_table>
   
  //update the c_pointer
  for (int i=c_pointer+1;i<NCONTAINER;i++)
80104b8e:	8b 15 c0 b9 10 80    	mov    0x8010b9c0,%edx
80104b94:	8d 42 01             	lea    0x1(%edx),%eax
80104b97:	83 f8 01             	cmp    $0x1,%eax
80104b9a:	7e 0c                	jle    80104ba8 <create_container+0x118>
80104b9c:	eb 2a                	jmp    80104bc8 <create_container+0x138>
80104b9e:	66 90                	xchg   %ax,%ax
80104ba0:	83 c0 01             	add    $0x1,%eax
80104ba3:	83 f8 02             	cmp    $0x2,%eax
80104ba6:	74 20                	je     80104bc8 <create_container+0x138>
    if (c_active[i] == 0)
80104ba8:	8b 0c 85 c4 b9 10 80 	mov    -0x7fef463c(,%eax,4),%ecx
80104baf:	85 c9                	test   %ecx,%ecx
80104bb1:	75 ed                	jne    80104ba0 <create_container+0x110>
      return output;
    }
  for (int i=0;i<c_pointer;i++)
    if (c_active[i] == 0)
    {
      c_pointer = i;
80104bb3:	a3 c0 b9 10 80       	mov    %eax,0x8010b9c0
      return output;
    }
  c_pointer = -1;
  return output;
}
80104bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bbb:	89 d8                	mov    %ebx,%eax
80104bbd:	5b                   	pop    %ebx
80104bbe:	5e                   	pop    %esi
80104bbf:	5f                   	pop    %edi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret    
80104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int i=0;i<c_pointer;i++)
80104bc8:	85 d2                	test   %edx,%edx
80104bca:	7e 17                	jle    80104be3 <create_container+0x153>
    if (c_active[i] == 0)
80104bcc:	a1 c4 b9 10 80       	mov    0x8010b9c4,%eax
80104bd1:	85 c0                	test   %eax,%eax
80104bd3:	74 de                	je     80104bb3 <create_container+0x123>
  for (int i=0;i<c_pointer;i++)
80104bd5:	83 fa 01             	cmp    $0x1,%edx
80104bd8:	74 09                	je     80104be3 <create_container+0x153>
    if (c_active[i] == 0)
80104bda:	a1 c8 b9 10 80       	mov    0x8010b9c8,%eax
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	74 14                	je     80104bf7 <create_container+0x167>
  c_pointer = -1;
80104be3:	c7 05 c0 b9 10 80 ff 	movl   $0xffffffff,0x8010b9c0
80104bea:	ff ff ff 
}
80104bed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bf0:	89 d8                	mov    %ebx,%eax
80104bf2:	5b                   	pop    %ebx
80104bf3:	5e                   	pop    %esi
80104bf4:	5f                   	pop    %edi
80104bf5:	5d                   	pop    %ebp
80104bf6:	c3                   	ret    
  for (int i=0;i<c_pointer;i++)
80104bf7:	b8 01 00 00 00       	mov    $0x1,%eax
80104bfc:	eb b5                	jmp    80104bb3 <create_container+0x123>
    cprintf("container_table full\n");
80104bfe:	83 ec 0c             	sub    $0xc,%esp
80104c01:	68 43 87 10 80       	push   $0x80108743
80104c06:	e8 55 ba ff ff       	call   80100660 <cprintf>
    return -1;
80104c0b:	83 c4 10             	add    $0x10,%esp
80104c0e:	eb a8                	jmp    80104bb8 <create_container+0x128>

80104c10 <destroy_container>:

int
destroy_container(int id)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 10             	sub    $0x10,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("in destroy_container\n");
80104c1a:	68 59 87 10 80       	push   $0x80108759
80104c1f:	e8 3c ba ff ff       	call   80100660 <cprintf>
  if (id < 0 || id >= NCONTAINER)
80104c24:	83 c4 10             	add    $0x10,%esp
80104c27:	83 fb 01             	cmp    $0x1,%ebx
80104c2a:	77 34                	ja     80104c60 <destroy_container+0x50>
    return -1;
  if (c_active[id] == 0)
80104c2c:	8b 04 9d c4 b9 10 80 	mov    -0x7fef463c(,%ebx,4),%eax
80104c33:	85 c0                	test   %eax,%eax
80104c35:	74 29                	je     80104c60 <destroy_container+0x50>
    return -1;
  c_active[id] = 0;
  if (c_pointer == -1)
80104c37:	83 3d c0 b9 10 80 ff 	cmpl   $0xffffffff,0x8010b9c0
  c_active[id] = 0;
80104c3e:	c7 04 9d c4 b9 10 80 	movl   $0x0,-0x7fef463c(,%ebx,4)
80104c45:	00 00 00 00 
  if (c_pointer == -1)
80104c49:	75 06                	jne    80104c51 <destroy_container+0x41>
    c_pointer = id;
80104c4b:	89 1d c0 b9 10 80    	mov    %ebx,0x8010b9c0
  
  print_c_table();
80104c51:	e8 9a fd ff ff       	call   801049f0 <print_c_table>

  return 0;
80104c56:	31 c0                	xor    %eax,%eax
}
80104c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5b:	c9                   	leave  
80104c5c:	c3                   	ret    
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c65:	eb f1                	jmp    80104c58 <destroy_container+0x48>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <join_container>:

int
join_container(int id)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  cprintf("in join_container\n");
80104c7c:	68 6f 87 10 80       	push   $0x8010876f
80104c81:	e8 da b9 ff ff       	call   80100660 <cprintf>
  if (id < 0 || id >= NCONTAINER || c_active[id] == 0)
80104c86:	83 c4 10             	add    $0x10,%esp
80104c89:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
80104c8d:	0f 87 64 01 00 00    	ja     80104df7 <join_container+0x187>
80104c93:	8b 45 08             	mov    0x8(%ebp),%eax
80104c96:	8b 3c 85 c4 b9 10 80 	mov    -0x7fef463c(,%eax,4),%edi
80104c9d:	85 ff                	test   %edi,%edi
80104c9f:	0f 84 52 01 00 00    	je     80104df7 <join_container+0x187>
    return -1;
  int pointer = container_table[id].process_pointer;
80104ca5:	69 d8 ac 01 00 00    	imul   $0x1ac,%eax,%ebx
80104cab:	8b 93 20 0d 13 80    	mov    -0x7fecf2e0(%ebx),%edx
80104cb1:	8d 83 00 0c 13 80    	lea    -0x7fecf400(%ebx),%eax
80104cb7:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  if (pointer == -1)
80104cbd:	83 fa ff             	cmp    $0xffffffff,%edx
80104cc0:	0f 84 e9 00 00 00    	je     80104daf <join_container+0x13f>
80104cc6:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
    return -1;
  
  struct proc p = *myproc();
80104ccc:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
  pushcli();
80104cd2:	e8 a9 03 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104cd7:	e8 c4 eb ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104cdc:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104ce2:	e8 d9 03 00 00       	call   801050c0 <popcli>
  //**imp**(not implemented):check if the process is already in a container 
  p.container_id = c_pointer;
  p.cont = &container_table[id];
  // if (sleepcustom(p.pid) == -1)
    // return -1;
  container_table[id].process_table[pointer] = p;
80104ce7:	a1 c0 b9 10 80       	mov    0x8010b9c0,%eax
80104cec:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  struct proc p = *myproc();
80104cf2:	b9 22 00 00 00       	mov    $0x22,%ecx
80104cf7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  container_table[id].process_table[pointer] = p;
80104cf9:	8d b5 60 ff ff ff    	lea    -0xa0(%ebp),%esi
80104cff:	b9 22 00 00 00       	mov    $0x22,%ecx
80104d04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  p.cont = &container_table[id];
80104d07:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
80104d0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  container_table[id].process_table[pointer] = p;
80104d10:	69 c2 88 00 00 00    	imul   $0x88,%edx,%eax
80104d16:	8d bc 03 08 0c 13 80 	lea    -0x7fecf3f8(%ebx,%eax,1),%edi
80104d1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  container_table[id].process_active[pointer] = 1;
80104d1f:	6b 75 08 6b          	imul   $0x6b,0x8(%ebp),%esi
80104d23:	8d 44 32 44          	lea    0x44(%edx,%esi,1),%eax
80104d27:	c7 04 85 08 0c 13 80 	movl   $0x1,-0x7fecf3f8(,%eax,4)
80104d2e:	01 00 00 00 

  print_c_table();
80104d32:	e8 b9 fc ff ff       	call   801049f0 <print_c_table>

  
  //update the c_pointer
  for (int i=c_pointer+1;i<NPROC_CONTAINER;i++)
80104d37:	8b 15 c0 b9 10 80    	mov    0x8010b9c0,%edx
80104d3d:	8d 42 01             	lea    0x1(%edx),%eax
80104d40:	83 f8 01             	cmp    $0x1,%eax
80104d43:	7f 2e                	jg     80104d73 <join_container+0x103>
    if (container_table[id].process_active[i] == 0)
80104d45:	8d 4c 30 44          	lea    0x44(%eax,%esi,1),%ecx
80104d49:	8b 34 8d 08 0c 13 80 	mov    -0x7fecf3f8(,%ecx,4),%esi
80104d50:	85 f6                	test   %esi,%esi
80104d52:	75 17                	jne    80104d6b <join_container+0xfb>
80104d54:	eb 6a                	jmp    80104dc0 <join_container+0x150>
80104d56:	8d 76 00             	lea    0x0(%esi),%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d60:	8b 8c 83 18 0d 13 80 	mov    -0x7fecf2e8(%ebx,%eax,4),%ecx
80104d67:	85 c9                	test   %ecx,%ecx
80104d69:	74 55                	je     80104dc0 <join_container+0x150>
  for (int i=c_pointer+1;i<NPROC_CONTAINER;i++)
80104d6b:	83 c0 01             	add    $0x1,%eax
80104d6e:	83 f8 02             	cmp    $0x2,%eax
80104d71:	75 ed                	jne    80104d60 <join_container+0xf0>
    {
      container_table[id].process_pointer = i;
      return 0;
    }
  for (int i=0;i<c_pointer;i++)
80104d73:	85 d2                	test   %edx,%edx
80104d75:	7e 25                	jle    80104d9c <join_container+0x12c>
    if (container_table[id].process_active[i] == 0)
80104d77:	69 45 08 ac 01 00 00 	imul   $0x1ac,0x8(%ebp),%eax
80104d7e:	05 00 0c 13 80       	add    $0x80130c00,%eax
80104d83:	8b 88 18 01 00 00    	mov    0x118(%eax),%ecx
80104d89:	85 c9                	test   %ecx,%ecx
80104d8b:	74 51                	je     80104dde <join_container+0x16e>
  for (int i=0;i<c_pointer;i++)
80104d8d:	83 fa 01             	cmp    $0x1,%edx
80104d90:	74 0a                	je     80104d9c <join_container+0x12c>
    if (container_table[id].process_active[i] == 0)
80104d92:	8b 80 1c 01 00 00    	mov    0x11c(%eax),%eax
80104d98:	85 c0                	test   %eax,%eax
80104d9a:	74 3d                	je     80104dd9 <join_container+0x169>
    {
      container_table[id].process_pointer = i;
      return 0;
    }
  container_table[id].process_pointer = -1;
80104d9c:	69 45 08 ac 01 00 00 	imul   $0x1ac,0x8(%ebp),%eax
  return 0;
80104da3:	31 d2                	xor    %edx,%edx
  container_table[id].process_pointer = -1;
80104da5:	c7 80 20 0d 13 80 ff 	movl   $0xffffffff,-0x7fecf2e0(%eax)
80104dac:	ff ff ff 
}
80104daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db2:	89 d0                	mov    %edx,%eax
80104db4:	5b                   	pop    %ebx
80104db5:	5e                   	pop    %esi
80104db6:	5f                   	pop    %edi
80104db7:	5d                   	pop    %ebp
80104db8:	c3                   	ret    
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      container_table[id].process_pointer = i;
80104dc0:	69 55 08 ac 01 00 00 	imul   $0x1ac,0x8(%ebp),%edx
80104dc7:	89 82 20 0d 13 80    	mov    %eax,-0x7fecf2e0(%edx)
}
80104dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80104dd0:	31 d2                	xor    %edx,%edx
}
80104dd2:	89 d0                	mov    %edx,%eax
80104dd4:	5b                   	pop    %ebx
80104dd5:	5e                   	pop    %esi
80104dd6:	5f                   	pop    %edi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret    
  for (int i=0;i<c_pointer;i++)
80104dd9:	b9 01 00 00 00       	mov    $0x1,%ecx
      container_table[id].process_pointer = i;
80104dde:	69 45 08 ac 01 00 00 	imul   $0x1ac,0x8(%ebp),%eax
      return 0;
80104de5:	31 d2                	xor    %edx,%edx
      container_table[id].process_pointer = i;
80104de7:	89 88 20 0d 13 80    	mov    %ecx,-0x7fecf2e0(%eax)
}
80104ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df0:	89 d0                	mov    %edx,%eax
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5f                   	pop    %edi
80104df5:	5d                   	pop    %ebp
80104df6:	c3                   	ret    
    return -1;
80104df7:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104dfc:	eb b1                	jmp    80104daf <join_container+0x13f>
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <leave_container>:

int
leave_container()
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
80104e04:	83 ec 10             	sub    $0x10,%esp
  cprintf("in leave_container\n");
80104e07:	68 82 87 10 80       	push   $0x80108782
80104e0c:	e8 4f b8 ff ff       	call   80100660 <cprintf>
  pushcli();
80104e11:	e8 6a 02 00 00       	call   80105080 <pushcli>
  c = mycpu();
80104e16:	e8 85 ea ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104e1b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e21:	e8 9a 02 00 00       	call   801050c0 <popcli>
  struct proc p = *myproc();
  int id = p.container_id;
  p.container_id = -1;
  if (id < 0 || id >= NCONTAINER || c_active[id] == 0)
80104e26:	83 c4 10             	add    $0x10,%esp
  struct proc p = *myproc();
80104e29:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104e2f:	8b 4b 10             	mov    0x10(%ebx),%ecx
  if (id < 0 || id >= NCONTAINER || c_active[id] == 0)
80104e32:	83 f8 01             	cmp    $0x1,%eax
80104e35:	77 79                	ja     80104eb0 <leave_container+0xb0>
80104e37:	8b 14 85 c4 b9 10 80 	mov    -0x7fef463c(,%eax,4),%edx
80104e3e:	85 d2                	test   %edx,%edx
80104e40:	74 6e                	je     80104eb0 <leave_container+0xb0>
    return -1;
  for (int i=0;i<NPROC_CONTAINER;i++)
    if (container_table[id].process_table[i].pid == p.pid && container_table[id].process_active[i] == 1)
80104e42:	69 d0 ac 01 00 00    	imul   $0x1ac,%eax,%edx
80104e48:	81 c2 00 0c 13 80    	add    $0x80130c00,%edx
80104e4e:	3b 4a 18             	cmp    0x18(%edx),%ecx
80104e51:	74 25                	je     80104e78 <leave_container+0x78>
80104e53:	69 d0 ac 01 00 00    	imul   $0x1ac,%eax,%edx
80104e59:	81 c2 00 0c 13 80    	add    $0x80130c00,%edx
80104e5f:	3b 8a a0 00 00 00    	cmp    0xa0(%edx),%ecx
80104e65:	74 39                	je     80104ea0 <leave_container+0xa0>
    {
      container_table[id].process_active[i] = 0;
      break;
    }
  print_c_table();
80104e67:	e8 84 fb ff ff       	call   801049f0 <print_c_table>
  
  return 0;  
80104e6c:	31 c0                	xor    %eax,%eax
}
80104e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e71:	c9                   	leave  
80104e72:	c3                   	ret    
80104e73:	90                   	nop
80104e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (container_table[id].process_table[i].pid == p.pid && container_table[id].process_active[i] == 1)
80104e78:	83 ba 18 01 00 00 01 	cmpl   $0x1,0x118(%edx)
80104e7f:	75 d2                	jne    80104e53 <leave_container+0x53>
  for (int i=0;i<NPROC_CONTAINER;i++)
80104e81:	31 d2                	xor    %edx,%edx
      container_table[id].process_active[i] = 0;
80104e83:	6b c0 6b             	imul   $0x6b,%eax,%eax
80104e86:	8d 44 02 44          	lea    0x44(%edx,%eax,1),%eax
80104e8a:	c7 04 85 08 0c 13 80 	movl   $0x0,-0x7fecf3f8(,%eax,4)
80104e91:	00 00 00 00 
      break;
80104e95:	eb d0                	jmp    80104e67 <leave_container+0x67>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (container_table[id].process_table[i].pid == p.pid && container_table[id].process_active[i] == 1)
80104ea0:	8b 92 1c 01 00 00    	mov    0x11c(%edx),%edx
80104ea6:	83 fa 01             	cmp    $0x1,%edx
80104ea9:	75 bc                	jne    80104e67 <leave_container+0x67>
80104eab:	eb d6                	jmp    80104e83 <leave_container+0x83>
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb5:	eb b7                	jmp    80104e6e <leave_container+0x6e>
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <container_malloc>:

int
container_malloc(int s)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	83 ec 14             	sub    $0x14,%esp
  cprintf("in container_malloc\n");
80104ec6:	68 96 87 10 80       	push   $0x80108796
80104ecb:	e8 90 b7 ff ff       	call   80100660 <cprintf>
  // int* t = ;
  return 0;
80104ed0:	31 c0                	xor    %eax,%eax
80104ed2:	c9                   	leave  
80104ed3:	c3                   	ret    
80104ed4:	66 90                	xchg   %ax,%ax
80104ed6:	66 90                	xchg   %ax,%ax
80104ed8:	66 90                	xchg   %ax,%ax
80104eda:	66 90                	xchg   %ax,%ax
80104edc:	66 90                	xchg   %ax,%ax
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104eea:	68 4c 88 10 80       	push   $0x8010884c
80104eef:	8d 43 04             	lea    0x4(%ebx),%eax
80104ef2:	50                   	push   %eax
80104ef3:	e8 18 01 00 00       	call   80105010 <initlock>
  lk->name = name;
80104ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104efb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f01:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f0b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f11:	c9                   	leave  
80104f12:	c3                   	ret    
80104f13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
80104f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f2e:	56                   	push   %esi
80104f2f:	e8 1c 02 00 00       	call   80105150 <acquire>
  while (lk->locked) {
80104f34:	8b 13                	mov    (%ebx),%edx
80104f36:	83 c4 10             	add    $0x10,%esp
80104f39:	85 d2                	test   %edx,%edx
80104f3b:	74 16                	je     80104f53 <acquiresleep+0x33>
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f40:	83 ec 08             	sub    $0x8,%esp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	e8 96 ef ff ff       	call   80103ee0 <sleep>
  while (lk->locked) {
80104f4a:	8b 03                	mov    (%ebx),%eax
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	85 c0                	test   %eax,%eax
80104f51:	75 ed                	jne    80104f40 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f59:	e8 e2 e9 ff ff       	call   80103940 <myproc>
80104f5e:	8b 40 10             	mov    0x10(%eax),%eax
80104f61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6a:	5b                   	pop    %ebx
80104f6b:	5e                   	pop    %esi
80104f6c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f6d:	e9 9e 02 00 00       	jmp    80105210 <release>
80104f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f8e:	56                   	push   %esi
80104f8f:	e8 bc 01 00 00       	call   80105150 <acquire>
  lk->locked = 0;
80104f94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104fa1:	89 1c 24             	mov    %ebx,(%esp)
80104fa4:	e8 f7 f0 ff ff       	call   801040a0 <wakeup>
  release(&lk->lk);
80104fa9:	89 75 08             	mov    %esi,0x8(%ebp)
80104fac:	83 c4 10             	add    $0x10,%esp
}
80104faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104fb5:	e9 56 02 00 00       	jmp    80105210 <release>
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	31 ff                	xor    %edi,%edi
80104fc8:	83 ec 18             	sub    $0x18,%esp
80104fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104fce:	8d 73 04             	lea    0x4(%ebx),%esi
80104fd1:	56                   	push   %esi
80104fd2:	e8 79 01 00 00       	call   80105150 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104fd7:	8b 03                	mov    (%ebx),%eax
80104fd9:	83 c4 10             	add    $0x10,%esp
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	74 13                	je     80104ff3 <holdingsleep+0x33>
80104fe0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104fe3:	e8 58 e9 ff ff       	call   80103940 <myproc>
80104fe8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104feb:	0f 94 c0             	sete   %al
80104fee:	0f b6 c0             	movzbl %al,%eax
80104ff1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ff3:	83 ec 0c             	sub    $0xc,%esp
80104ff6:	56                   	push   %esi
80104ff7:	e8 14 02 00 00       	call   80105210 <release>
  return r;
}
80104ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fff:	89 f8                	mov    %edi,%eax
80105001:	5b                   	pop    %ebx
80105002:	5e                   	pop    %esi
80105003:	5f                   	pop    %edi
80105004:	5d                   	pop    %ebp
80105005:	c3                   	ret    
80105006:	66 90                	xchg   %ax,%ax
80105008:	66 90                	xchg   %ax,%ax
8010500a:	66 90                	xchg   %ax,%ax
8010500c:	66 90                	xchg   %ax,%ax
8010500e:	66 90                	xchg   %ax,%ax

80105010 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105016:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010501f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105022:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    
8010502b:	90                   	nop
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105030 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105030:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105031:	31 d2                	xor    %edx,%edx
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010503c:	83 e8 08             	sub    $0x8,%eax
8010503f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105040:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105046:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010504c:	77 1a                	ja     80105068 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010504e:	8b 58 04             	mov    0x4(%eax),%ebx
80105051:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105054:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105057:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105059:	83 fa 0a             	cmp    $0xa,%edx
8010505c:	75 e2                	jne    80105040 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010505e:	5b                   	pop    %ebx
8010505f:	5d                   	pop    %ebp
80105060:	c3                   	ret    
80105061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105068:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010506b:	83 c1 28             	add    $0x28,%ecx
8010506e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105076:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105079:	39 c1                	cmp    %eax,%ecx
8010507b:	75 f3                	jne    80105070 <getcallerpcs+0x40>
}
8010507d:	5b                   	pop    %ebx
8010507e:	5d                   	pop    %ebp
8010507f:	c3                   	ret    

80105080 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	53                   	push   %ebx
80105084:	83 ec 04             	sub    $0x4,%esp
80105087:	9c                   	pushf  
80105088:	5b                   	pop    %ebx
  asm volatile("cli");
80105089:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010508a:	e8 11 e8 ff ff       	call   801038a0 <mycpu>
8010508f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105095:	85 c0                	test   %eax,%eax
80105097:	75 11                	jne    801050aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105099:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010509f:	e8 fc e7 ff ff       	call   801038a0 <mycpu>
801050a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801050aa:	e8 f1 e7 ff ff       	call   801038a0 <mycpu>
801050af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801050b6:	83 c4 04             	add    $0x4,%esp
801050b9:	5b                   	pop    %ebx
801050ba:	5d                   	pop    %ebp
801050bb:	c3                   	ret    
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050c0 <popcli>:

void
popcli(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050c6:	9c                   	pushf  
801050c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801050c8:	f6 c4 02             	test   $0x2,%ah
801050cb:	75 35                	jne    80105102 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801050cd:	e8 ce e7 ff ff       	call   801038a0 <mycpu>
801050d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801050d9:	78 34                	js     8010510f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050db:	e8 c0 e7 ff ff       	call   801038a0 <mycpu>
801050e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050e6:	85 d2                	test   %edx,%edx
801050e8:	74 06                	je     801050f0 <popcli+0x30>
    sti();
}
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050f0:	e8 ab e7 ff ff       	call   801038a0 <mycpu>
801050f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050fb:	85 c0                	test   %eax,%eax
801050fd:	74 eb                	je     801050ea <popcli+0x2a>
  asm volatile("sti");
801050ff:	fb                   	sti    
}
80105100:	c9                   	leave  
80105101:	c3                   	ret    
    panic("popcli - interruptible");
80105102:	83 ec 0c             	sub    $0xc,%esp
80105105:	68 57 88 10 80       	push   $0x80108857
8010510a:	e8 81 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	68 6e 88 10 80       	push   $0x8010886e
80105117:	e8 74 b2 ff ff       	call   80100390 <panic>
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <holding>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 75 08             	mov    0x8(%ebp),%esi
80105128:	31 db                	xor    %ebx,%ebx
  pushcli();
8010512a:	e8 51 ff ff ff       	call   80105080 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010512f:	8b 06                	mov    (%esi),%eax
80105131:	85 c0                	test   %eax,%eax
80105133:	74 10                	je     80105145 <holding+0x25>
80105135:	8b 5e 08             	mov    0x8(%esi),%ebx
80105138:	e8 63 e7 ff ff       	call   801038a0 <mycpu>
8010513d:	39 c3                	cmp    %eax,%ebx
8010513f:	0f 94 c3             	sete   %bl
80105142:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105145:	e8 76 ff ff ff       	call   801050c0 <popcli>
}
8010514a:	89 d8                	mov    %ebx,%eax
8010514c:	5b                   	pop    %ebx
8010514d:	5e                   	pop    %esi
8010514e:	5d                   	pop    %ebp
8010514f:	c3                   	ret    

80105150 <acquire>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105155:	e8 26 ff ff ff       	call   80105080 <pushcli>
  if(holding(lk))
8010515a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	53                   	push   %ebx
80105161:	e8 ba ff ff ff       	call   80105120 <holding>
80105166:	83 c4 10             	add    $0x10,%esp
80105169:	85 c0                	test   %eax,%eax
8010516b:	0f 85 83 00 00 00    	jne    801051f4 <acquire+0xa4>
80105171:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105173:	ba 01 00 00 00       	mov    $0x1,%edx
80105178:	eb 09                	jmp    80105183 <acquire+0x33>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105180:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105183:	89 d0                	mov    %edx,%eax
80105185:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105188:	85 c0                	test   %eax,%eax
8010518a:	75 f4                	jne    80105180 <acquire+0x30>
  __sync_synchronize();
8010518c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105191:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105194:	e8 07 e7 ff ff       	call   801038a0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105199:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010519c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010519f:	89 e8                	mov    %ebp,%eax
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051a8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801051ae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801051b4:	77 1a                	ja     801051d0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801051b6:	8b 48 04             	mov    0x4(%eax),%ecx
801051b9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801051bc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801051bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801051c1:	83 fe 0a             	cmp    $0xa,%esi
801051c4:	75 e2                	jne    801051a8 <acquire+0x58>
}
801051c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801051d3:	83 c2 28             	add    $0x28,%edx
801051d6:	8d 76 00             	lea    0x0(%esi),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801051e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801051e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801051e9:	39 d0                	cmp    %edx,%eax
801051eb:	75 f3                	jne    801051e0 <acquire+0x90>
}
801051ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f0:	5b                   	pop    %ebx
801051f1:	5e                   	pop    %esi
801051f2:	5d                   	pop    %ebp
801051f3:	c3                   	ret    
    panic("acquire");
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 75 88 10 80       	push   $0x80108875
801051fc:	e8 8f b1 ff ff       	call   80100390 <panic>
80105201:	eb 0d                	jmp    80105210 <release>
80105203:	90                   	nop
80105204:	90                   	nop
80105205:	90                   	nop
80105206:	90                   	nop
80105207:	90                   	nop
80105208:	90                   	nop
80105209:	90                   	nop
8010520a:	90                   	nop
8010520b:	90                   	nop
8010520c:	90                   	nop
8010520d:	90                   	nop
8010520e:	90                   	nop
8010520f:	90                   	nop

80105210 <release>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 10             	sub    $0x10,%esp
80105217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010521a:	53                   	push   %ebx
8010521b:	e8 00 ff ff ff       	call   80105120 <holding>
80105220:	83 c4 10             	add    $0x10,%esp
80105223:	85 c0                	test   %eax,%eax
80105225:	74 22                	je     80105249 <release+0x39>
  lk->pcs[0] = 0;
80105227:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010522e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105235:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010523a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105243:	c9                   	leave  
  popcli();
80105244:	e9 77 fe ff ff       	jmp    801050c0 <popcli>
    panic("release");
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 7d 88 10 80       	push   $0x8010887d
80105251:	e8 3a b1 ff ff       	call   80100390 <panic>
80105256:	66 90                	xchg   %ax,%ax
80105258:	66 90                	xchg   %ax,%ax
8010525a:	66 90                	xchg   %ax,%ax
8010525c:	66 90                	xchg   %ax,%ax
8010525e:	66 90                	xchg   %ax,%ax

80105260 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	53                   	push   %ebx
80105265:	8b 55 08             	mov    0x8(%ebp),%edx
80105268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010526b:	f6 c2 03             	test   $0x3,%dl
8010526e:	75 05                	jne    80105275 <memset+0x15>
80105270:	f6 c1 03             	test   $0x3,%cl
80105273:	74 13                	je     80105288 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105275:	89 d7                	mov    %edx,%edi
80105277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527a:	fc                   	cld    
8010527b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010527d:	5b                   	pop    %ebx
8010527e:	89 d0                	mov    %edx,%eax
80105280:	5f                   	pop    %edi
80105281:	5d                   	pop    %ebp
80105282:	c3                   	ret    
80105283:	90                   	nop
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105288:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010528c:	c1 e9 02             	shr    $0x2,%ecx
8010528f:	89 f8                	mov    %edi,%eax
80105291:	89 fb                	mov    %edi,%ebx
80105293:	c1 e0 18             	shl    $0x18,%eax
80105296:	c1 e3 10             	shl    $0x10,%ebx
80105299:	09 d8                	or     %ebx,%eax
8010529b:	09 f8                	or     %edi,%eax
8010529d:	c1 e7 08             	shl    $0x8,%edi
801052a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801052a2:	89 d7                	mov    %edx,%edi
801052a4:	fc                   	cld    
801052a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801052a7:	5b                   	pop    %ebx
801052a8:	89 d0                	mov    %edx,%eax
801052aa:	5f                   	pop    %edi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
801052b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801052b9:	8b 75 08             	mov    0x8(%ebp),%esi
801052bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052bf:	85 db                	test   %ebx,%ebx
801052c1:	74 29                	je     801052ec <memcmp+0x3c>
    if(*s1 != *s2)
801052c3:	0f b6 16             	movzbl (%esi),%edx
801052c6:	0f b6 0f             	movzbl (%edi),%ecx
801052c9:	38 d1                	cmp    %dl,%cl
801052cb:	75 2b                	jne    801052f8 <memcmp+0x48>
801052cd:	b8 01 00 00 00       	mov    $0x1,%eax
801052d2:	eb 14                	jmp    801052e8 <memcmp+0x38>
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801052dc:	83 c0 01             	add    $0x1,%eax
801052df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801052e4:	38 ca                	cmp    %cl,%dl
801052e6:	75 10                	jne    801052f8 <memcmp+0x48>
  while(n-- > 0){
801052e8:	39 d8                	cmp    %ebx,%eax
801052ea:	75 ec                	jne    801052d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801052ec:	5b                   	pop    %ebx
  return 0;
801052ed:	31 c0                	xor    %eax,%eax
}
801052ef:	5e                   	pop    %esi
801052f0:	5f                   	pop    %edi
801052f1:	5d                   	pop    %ebp
801052f2:	c3                   	ret    
801052f3:	90                   	nop
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801052f8:	0f b6 c2             	movzbl %dl,%eax
}
801052fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801052fc:	29 c8                	sub    %ecx,%eax
}
801052fe:	5e                   	pop    %esi
801052ff:	5f                   	pop    %edi
80105300:	5d                   	pop    %ebp
80105301:	c3                   	ret    
80105302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
80105315:	8b 45 08             	mov    0x8(%ebp),%eax
80105318:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010531b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010531e:	39 c3                	cmp    %eax,%ebx
80105320:	73 26                	jae    80105348 <memmove+0x38>
80105322:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105325:	39 c8                	cmp    %ecx,%eax
80105327:	73 1f                	jae    80105348 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105329:	85 f6                	test   %esi,%esi
8010532b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010532e:	74 0f                	je     8010533f <memmove+0x2f>
      *--d = *--s;
80105330:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105334:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105337:	83 ea 01             	sub    $0x1,%edx
8010533a:	83 fa ff             	cmp    $0xffffffff,%edx
8010533d:	75 f1                	jne    80105330 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010533f:	5b                   	pop    %ebx
80105340:	5e                   	pop    %esi
80105341:	5d                   	pop    %ebp
80105342:	c3                   	ret    
80105343:	90                   	nop
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105348:	31 d2                	xor    %edx,%edx
8010534a:	85 f6                	test   %esi,%esi
8010534c:	74 f1                	je     8010533f <memmove+0x2f>
8010534e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105350:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105354:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105357:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010535a:	39 d6                	cmp    %edx,%esi
8010535c:	75 f2                	jne    80105350 <memmove+0x40>
}
8010535e:	5b                   	pop    %ebx
8010535f:	5e                   	pop    %esi
80105360:	5d                   	pop    %ebp
80105361:	c3                   	ret    
80105362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105373:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105374:	eb 9a                	jmp    80105310 <memmove>
80105376:	8d 76 00             	lea    0x0(%esi),%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	8b 7d 10             	mov    0x10(%ebp),%edi
80105388:	53                   	push   %ebx
80105389:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010538c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010538f:	85 ff                	test   %edi,%edi
80105391:	74 2f                	je     801053c2 <strncmp+0x42>
80105393:	0f b6 01             	movzbl (%ecx),%eax
80105396:	0f b6 1e             	movzbl (%esi),%ebx
80105399:	84 c0                	test   %al,%al
8010539b:	74 37                	je     801053d4 <strncmp+0x54>
8010539d:	38 c3                	cmp    %al,%bl
8010539f:	75 33                	jne    801053d4 <strncmp+0x54>
801053a1:	01 f7                	add    %esi,%edi
801053a3:	eb 13                	jmp    801053b8 <strncmp+0x38>
801053a5:	8d 76 00             	lea    0x0(%esi),%esi
801053a8:	0f b6 01             	movzbl (%ecx),%eax
801053ab:	84 c0                	test   %al,%al
801053ad:	74 21                	je     801053d0 <strncmp+0x50>
801053af:	0f b6 1a             	movzbl (%edx),%ebx
801053b2:	89 d6                	mov    %edx,%esi
801053b4:	38 d8                	cmp    %bl,%al
801053b6:	75 1c                	jne    801053d4 <strncmp+0x54>
    n--, p++, q++;
801053b8:	8d 56 01             	lea    0x1(%esi),%edx
801053bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801053be:	39 fa                	cmp    %edi,%edx
801053c0:	75 e6                	jne    801053a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801053c2:	5b                   	pop    %ebx
    return 0;
801053c3:	31 c0                	xor    %eax,%eax
}
801053c5:	5e                   	pop    %esi
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801053d4:	29 d8                	sub    %ebx,%eax
}
801053d6:	5b                   	pop    %ebx
801053d7:	5e                   	pop    %esi
801053d8:	5f                   	pop    %edi
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	90                   	nop
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	8b 45 08             	mov    0x8(%ebp),%eax
801053e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053ee:	89 c2                	mov    %eax,%edx
801053f0:	eb 19                	jmp    8010540b <strncpy+0x2b>
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053f8:	83 c3 01             	add    $0x1,%ebx
801053fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801053ff:	83 c2 01             	add    $0x1,%edx
80105402:	84 c9                	test   %cl,%cl
80105404:	88 4a ff             	mov    %cl,-0x1(%edx)
80105407:	74 09                	je     80105412 <strncpy+0x32>
80105409:	89 f1                	mov    %esi,%ecx
8010540b:	85 c9                	test   %ecx,%ecx
8010540d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105410:	7f e6                	jg     801053f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105412:	31 c9                	xor    %ecx,%ecx
80105414:	85 f6                	test   %esi,%esi
80105416:	7e 17                	jle    8010542f <strncpy+0x4f>
80105418:	90                   	nop
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105420:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105424:	89 f3                	mov    %esi,%ebx
80105426:	83 c1 01             	add    $0x1,%ecx
80105429:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010542b:	85 db                	test   %ebx,%ebx
8010542d:	7f f1                	jg     80105420 <strncpy+0x40>
  return os;
}
8010542f:	5b                   	pop    %ebx
80105430:	5e                   	pop    %esi
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    
80105433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105448:	8b 45 08             	mov    0x8(%ebp),%eax
8010544b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010544e:	85 c9                	test   %ecx,%ecx
80105450:	7e 26                	jle    80105478 <safestrcpy+0x38>
80105452:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105456:	89 c1                	mov    %eax,%ecx
80105458:	eb 17                	jmp    80105471 <safestrcpy+0x31>
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105460:	83 c2 01             	add    $0x1,%edx
80105463:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105467:	83 c1 01             	add    $0x1,%ecx
8010546a:	84 db                	test   %bl,%bl
8010546c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010546f:	74 04                	je     80105475 <safestrcpy+0x35>
80105471:	39 f2                	cmp    %esi,%edx
80105473:	75 eb                	jne    80105460 <safestrcpy+0x20>
    ;
  *s = 0;
80105475:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105478:	5b                   	pop    %ebx
80105479:	5e                   	pop    %esi
8010547a:	5d                   	pop    %ebp
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <strlen>:

int
strlen(const char *s)
{
80105480:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105481:	31 c0                	xor    %eax,%eax
{
80105483:	89 e5                	mov    %esp,%ebp
80105485:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105488:	80 3a 00             	cmpb   $0x0,(%edx)
8010548b:	74 0c                	je     80105499 <strlen+0x19>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
80105490:	83 c0 01             	add    $0x1,%eax
80105493:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105497:	75 f7                	jne    80105490 <strlen+0x10>
    ;
  return n;
}
80105499:	5d                   	pop    %ebp
8010549a:	c3                   	ret    

8010549b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010549b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010549f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801054a3:	55                   	push   %ebp
  pushl %ebx
801054a4:	53                   	push   %ebx
  pushl %esi
801054a5:	56                   	push   %esi
  pushl %edi
801054a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801054ab:	5f                   	pop    %edi
  popl %esi
801054ac:	5e                   	pop    %esi
  popl %ebx
801054ad:	5b                   	pop    %ebx
  popl %ebp
801054ae:	5d                   	pop    %ebp
  ret
801054af:	c3                   	ret    

801054b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 04             	sub    $0x4,%esp
801054b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054ba:	e8 81 e4 ff ff       	call   80103940 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054bf:	8b 00                	mov    (%eax),%eax
801054c1:	39 d8                	cmp    %ebx,%eax
801054c3:	76 1b                	jbe    801054e0 <fetchint+0x30>
801054c5:	8d 53 04             	lea    0x4(%ebx),%edx
801054c8:	39 d0                	cmp    %edx,%eax
801054ca:	72 14                	jb     801054e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cf:	8b 13                	mov    (%ebx),%edx
801054d1:	89 10                	mov    %edx,(%eax)
  return 0;
801054d3:	31 c0                	xor    %eax,%eax
}
801054d5:	83 c4 04             	add    $0x4,%esp
801054d8:	5b                   	pop    %ebx
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	90                   	nop
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e5:	eb ee                	jmp    801054d5 <fetchint+0x25>
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 04             	sub    $0x4,%esp
801054f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054fa:	e8 41 e4 ff ff       	call   80103940 <myproc>

  if(addr >= curproc->sz)
801054ff:	39 18                	cmp    %ebx,(%eax)
80105501:	76 29                	jbe    8010552c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105506:	89 da                	mov    %ebx,%edx
80105508:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010550a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010550c:	39 c3                	cmp    %eax,%ebx
8010550e:	73 1c                	jae    8010552c <fetchstr+0x3c>
    if(*s == 0)
80105510:	80 3b 00             	cmpb   $0x0,(%ebx)
80105513:	75 10                	jne    80105525 <fetchstr+0x35>
80105515:	eb 39                	jmp    80105550 <fetchstr+0x60>
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105520:	80 3a 00             	cmpb   $0x0,(%edx)
80105523:	74 1b                	je     80105540 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105525:	83 c2 01             	add    $0x1,%edx
80105528:	39 d0                	cmp    %edx,%eax
8010552a:	77 f4                	ja     80105520 <fetchstr+0x30>
    return -1;
8010552c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105531:	83 c4 04             	add    $0x4,%esp
80105534:	5b                   	pop    %ebx
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105540:	83 c4 04             	add    $0x4,%esp
80105543:	89 d0                	mov    %edx,%eax
80105545:	29 d8                	sub    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5d                   	pop    %ebp
80105549:	c3                   	ret    
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105550:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105552:	eb dd                	jmp    80105531 <fetchstr+0x41>
80105554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010555a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105560 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105565:	e8 d6 e3 ff ff       	call   80103940 <myproc>
8010556a:	8b 40 18             	mov    0x18(%eax),%eax
8010556d:	8b 55 08             	mov    0x8(%ebp),%edx
80105570:	8b 40 44             	mov    0x44(%eax),%eax
80105573:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105576:	e8 c5 e3 ff ff       	call   80103940 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010557b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010557d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105580:	39 c6                	cmp    %eax,%esi
80105582:	73 1c                	jae    801055a0 <argint+0x40>
80105584:	8d 53 08             	lea    0x8(%ebx),%edx
80105587:	39 d0                	cmp    %edx,%eax
80105589:	72 15                	jb     801055a0 <argint+0x40>
  *ip = *(int*)(addr);
8010558b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558e:	8b 53 04             	mov    0x4(%ebx),%edx
80105591:	89 10                	mov    %edx,(%eax)
  return 0;
80105593:	31 c0                	xor    %eax,%eax
}
80105595:	5b                   	pop    %ebx
80105596:	5e                   	pop    %esi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret    
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055a5:	eb ee                	jmp    80105595 <argint+0x35>
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
801055b5:	83 ec 10             	sub    $0x10,%esp
801055b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801055bb:	e8 80 e3 ff ff       	call   80103940 <myproc>
801055c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801055c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	50                   	push   %eax
801055c9:	ff 75 08             	pushl  0x8(%ebp)
801055cc:	e8 8f ff ff ff       	call   80105560 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 28                	js     80105600 <argptr+0x50>
801055d8:	85 db                	test   %ebx,%ebx
801055da:	78 24                	js     80105600 <argptr+0x50>
801055dc:	8b 16                	mov    (%esi),%edx
801055de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e1:	39 c2                	cmp    %eax,%edx
801055e3:	76 1b                	jbe    80105600 <argptr+0x50>
801055e5:	01 c3                	add    %eax,%ebx
801055e7:	39 da                	cmp    %ebx,%edx
801055e9:	72 15                	jb     80105600 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801055eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801055ee:	89 02                	mov    %eax,(%edx)
  return 0;
801055f0:	31 c0                	xor    %eax,%eax
}
801055f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f5:	5b                   	pop    %ebx
801055f6:	5e                   	pop    %esi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105605:	eb eb                	jmp    801055f2 <argptr+0x42>
80105607:	89 f6                	mov    %esi,%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	50                   	push   %eax
8010561a:	ff 75 08             	pushl  0x8(%ebp)
8010561d:	e8 3e ff ff ff       	call   80105560 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 17                	js     80105640 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105629:	83 ec 08             	sub    $0x8,%esp
8010562c:	ff 75 0c             	pushl  0xc(%ebp)
8010562f:	ff 75 f4             	pushl  -0xc(%ebp)
80105632:	e8 b9 fe ff ff       	call   801054f0 <fetchstr>
80105637:	83 c4 10             	add    $0x10,%esp
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <syscall>:
[SYS_container_malloc]	  sys_container_malloc
};

void
syscall(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	53                   	push   %ebx
80105654:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105657:	e8 e4 e2 ff ff       	call   80103940 <myproc>
8010565c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010565e:	8b 40 18             	mov    0x18(%eax),%eax
80105661:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105664:	8d 50 ff             	lea    -0x1(%eax),%edx
80105667:	83 fa 24             	cmp    $0x24,%edx
8010566a:	77 2c                	ja     80105698 <syscall+0x48>
8010566c:	8b 0c 85 c0 88 10 80 	mov    -0x7fef7740(,%eax,4),%ecx
80105673:	85 c9                	test   %ecx,%ecx
80105675:	74 21                	je     80105698 <syscall+0x48>
  	if (trace == 1)
80105677:	83 3d 64 ba 10 80 01 	cmpl   $0x1,0x8010ba64
8010567e:	75 08                	jne    80105688 <syscall+0x38>
  		counter[num-1] = counter[num-1] + 1;
80105680:	83 04 95 e0 b9 10 80 	addl   $0x1,-0x7fef4620(,%edx,4)
80105687:	01 
    curproc->tf->eax = syscalls[num]();
80105688:	ff d1                	call   *%ecx
8010568a:	8b 53 18             	mov    0x18(%ebx),%edx
8010568d:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105693:	c9                   	leave  
80105694:	c3                   	ret    
80105695:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105698:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105699:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010569c:	50                   	push   %eax
8010569d:	ff 73 10             	pushl  0x10(%ebx)
801056a0:	68 85 88 10 80       	push   $0x80108885
801056a5:	e8 b6 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801056aa:	8b 43 18             	mov    0x18(%ebx),%eax
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801056b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	66 90                	xchg   %ax,%ax
801056be:	66 90                	xchg   %ax,%ax

801056c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056c6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056c9:	83 ec 44             	sub    $0x44,%esp
801056cc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801056cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056d2:	56                   	push   %esi
801056d3:	50                   	push   %eax
{
801056d4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801056d7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056da:	e8 31 c8 ff ff       	call   80101f10 <nameiparent>
801056df:	83 c4 10             	add    $0x10,%esp
801056e2:	85 c0                	test   %eax,%eax
801056e4:	0f 84 46 01 00 00    	je     80105830 <create+0x170>
    return 0;
  ilock(dp);
801056ea:	83 ec 0c             	sub    $0xc,%esp
801056ed:	89 c3                	mov    %eax,%ebx
801056ef:	50                   	push   %eax
801056f0:	e8 9b bf ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801056f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801056f8:	83 c4 0c             	add    $0xc,%esp
801056fb:	50                   	push   %eax
801056fc:	56                   	push   %esi
801056fd:	53                   	push   %ebx
801056fe:	e8 bd c4 ff ff       	call   80101bc0 <dirlookup>
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	89 c7                	mov    %eax,%edi
8010570a:	74 34                	je     80105740 <create+0x80>
    iunlockput(dp);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	53                   	push   %ebx
80105710:	e8 0b c2 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80105715:	89 3c 24             	mov    %edi,(%esp)
80105718:	e8 73 bf ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105725:	0f 85 95 00 00 00    	jne    801057c0 <create+0x100>
8010572b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105730:	0f 85 8a 00 00 00    	jne    801057c0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105736:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105739:	89 f8                	mov    %edi,%eax
8010573b:	5b                   	pop    %ebx
8010573c:	5e                   	pop    %esi
8010573d:	5f                   	pop    %edi
8010573e:	5d                   	pop    %ebp
8010573f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105740:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105744:	83 ec 08             	sub    $0x8,%esp
80105747:	50                   	push   %eax
80105748:	ff 33                	pushl  (%ebx)
8010574a:	e8 d1 bd ff ff       	call   80101520 <ialloc>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	85 c0                	test   %eax,%eax
80105754:	89 c7                	mov    %eax,%edi
80105756:	0f 84 e8 00 00 00    	je     80105844 <create+0x184>
  ilock(ip);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	50                   	push   %eax
80105760:	e8 2b bf ff ff       	call   80101690 <ilock>
  ip->major = major;
80105765:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105769:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010576d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105771:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105775:	b8 01 00 00 00       	mov    $0x1,%eax
8010577a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010577e:	89 3c 24             	mov    %edi,(%esp)
80105781:	e8 5a be ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010578e:	74 50                	je     801057e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105790:	83 ec 04             	sub    $0x4,%esp
80105793:	ff 77 04             	pushl  0x4(%edi)
80105796:	56                   	push   %esi
80105797:	53                   	push   %ebx
80105798:	e8 93 c6 ff ff       	call   80101e30 <dirlink>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	0f 88 8f 00 00 00    	js     80105837 <create+0x177>
  iunlockput(dp);
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	53                   	push   %ebx
801057ac:	e8 6f c1 ff ff       	call   80101920 <iunlockput>
  return ip;
801057b1:	83 c4 10             	add    $0x10,%esp
}
801057b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b7:	89 f8                	mov    %edi,%eax
801057b9:	5b                   	pop    %ebx
801057ba:	5e                   	pop    %esi
801057bb:	5f                   	pop    %edi
801057bc:	5d                   	pop    %ebp
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	57                   	push   %edi
    return 0;
801057c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057c6:	e8 55 c1 ff ff       	call   80101920 <iunlockput>
    return 0;
801057cb:	83 c4 10             	add    $0x10,%esp
}
801057ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d1:	89 f8                	mov    %edi,%eax
801057d3:	5b                   	pop    %ebx
801057d4:	5e                   	pop    %esi
801057d5:	5f                   	pop    %edi
801057d6:	5d                   	pop    %ebp
801057d7:	c3                   	ret    
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057e5:	83 ec 0c             	sub    $0xc,%esp
801057e8:	53                   	push   %ebx
801057e9:	e8 f2 bd ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057ee:	83 c4 0c             	add    $0xc,%esp
801057f1:	ff 77 04             	pushl  0x4(%edi)
801057f4:	68 74 89 10 80       	push   $0x80108974
801057f9:	57                   	push   %edi
801057fa:	e8 31 c6 ff ff       	call   80101e30 <dirlink>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 1c                	js     80105822 <create+0x162>
80105806:	83 ec 04             	sub    $0x4,%esp
80105809:	ff 73 04             	pushl  0x4(%ebx)
8010580c:	68 73 89 10 80       	push   $0x80108973
80105811:	57                   	push   %edi
80105812:	e8 19 c6 ff ff       	call   80101e30 <dirlink>
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 c0                	test   %eax,%eax
8010581c:	0f 89 6e ff ff ff    	jns    80105790 <create+0xd0>
      panic("create dots");
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	68 67 89 10 80       	push   $0x80108967
8010582a:	e8 61 ab ff ff       	call   80100390 <panic>
8010582f:	90                   	nop
    return 0;
80105830:	31 ff                	xor    %edi,%edi
80105832:	e9 ff fe ff ff       	jmp    80105736 <create+0x76>
    panic("create: dirlink");
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	68 76 89 10 80       	push   $0x80108976
8010583f:	e8 4c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	68 58 89 10 80       	push   $0x80108958
8010584c:	e8 3f ab ff ff       	call   80100390 <panic>
80105851:	eb 0d                	jmp    80105860 <argfd.constprop.0>
80105853:	90                   	nop
80105854:	90                   	nop
80105855:	90                   	nop
80105856:	90                   	nop
80105857:	90                   	nop
80105858:	90                   	nop
80105859:	90                   	nop
8010585a:	90                   	nop
8010585b:	90                   	nop
8010585c:	90                   	nop
8010585d:	90                   	nop
8010585e:	90                   	nop
8010585f:	90                   	nop

80105860 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105867:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010586a:	89 d6                	mov    %edx,%esi
8010586c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010586f:	50                   	push   %eax
80105870:	6a 00                	push   $0x0
80105872:	e8 e9 fc ff ff       	call   80105560 <argint>
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	85 c0                	test   %eax,%eax
8010587c:	78 2a                	js     801058a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010587e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105882:	77 24                	ja     801058a8 <argfd.constprop.0+0x48>
80105884:	e8 b7 e0 ff ff       	call   80103940 <myproc>
80105889:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010588c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105890:	85 c0                	test   %eax,%eax
80105892:	74 14                	je     801058a8 <argfd.constprop.0+0x48>
  if(pfd)
80105894:	85 db                	test   %ebx,%ebx
80105896:	74 02                	je     8010589a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105898:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010589a:	89 06                	mov    %eax,(%esi)
  return 0;
8010589c:	31 c0                	xor    %eax,%eax
}
8010589e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058a1:	5b                   	pop    %ebx
801058a2:	5e                   	pop    %esi
801058a3:	5d                   	pop    %ebp
801058a4:	c3                   	ret    
801058a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ad:	eb ef                	jmp    8010589e <argfd.constprop.0+0x3e>
801058af:	90                   	nop

801058b0 <sys_dup>:
{
801058b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801058b1:	31 c0                	xor    %eax,%eax
{
801058b3:	89 e5                	mov    %esp,%ebp
801058b5:	56                   	push   %esi
801058b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801058b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801058ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801058bd:	e8 9e ff ff ff       	call   80105860 <argfd.constprop.0>
801058c2:	85 c0                	test   %eax,%eax
801058c4:	78 42                	js     80105908 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801058c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058cb:	e8 70 e0 ff ff       	call   80103940 <myproc>
801058d0:	eb 0e                	jmp    801058e0 <sys_dup+0x30>
801058d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058d8:	83 c3 01             	add    $0x1,%ebx
801058db:	83 fb 10             	cmp    $0x10,%ebx
801058de:	74 28                	je     80105908 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801058e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058e4:	85 d2                	test   %edx,%edx
801058e6:	75 f0                	jne    801058d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801058e8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801058ec:	83 ec 0c             	sub    $0xc,%esp
801058ef:	ff 75 f4             	pushl  -0xc(%ebp)
801058f2:	e8 f9 b4 ff ff       	call   80100df0 <filedup>
  return fd;
801058f7:	83 c4 10             	add    $0x10,%esp
}
801058fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058fd:	89 d8                	mov    %ebx,%eax
801058ff:	5b                   	pop    %ebx
80105900:	5e                   	pop    %esi
80105901:	5d                   	pop    %ebp
80105902:	c3                   	ret    
80105903:	90                   	nop
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105908:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010590b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105910:	89 d8                	mov    %ebx,%eax
80105912:	5b                   	pop    %ebx
80105913:	5e                   	pop    %esi
80105914:	5d                   	pop    %ebp
80105915:	c3                   	ret    
80105916:	8d 76 00             	lea    0x0(%esi),%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <sys_read>:
{
80105920:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105921:	31 c0                	xor    %eax,%eax
{
80105923:	89 e5                	mov    %esp,%ebp
80105925:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105928:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010592b:	e8 30 ff ff ff       	call   80105860 <argfd.constprop.0>
80105930:	85 c0                	test   %eax,%eax
80105932:	78 4c                	js     80105980 <sys_read+0x60>
80105934:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105937:	83 ec 08             	sub    $0x8,%esp
8010593a:	50                   	push   %eax
8010593b:	6a 02                	push   $0x2
8010593d:	e8 1e fc ff ff       	call   80105560 <argint>
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	85 c0                	test   %eax,%eax
80105947:	78 37                	js     80105980 <sys_read+0x60>
80105949:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594c:	83 ec 04             	sub    $0x4,%esp
8010594f:	ff 75 f0             	pushl  -0x10(%ebp)
80105952:	50                   	push   %eax
80105953:	6a 01                	push   $0x1
80105955:	e8 56 fc ff ff       	call   801055b0 <argptr>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	85 c0                	test   %eax,%eax
8010595f:	78 1f                	js     80105980 <sys_read+0x60>
  return fileread(f, p, n);
80105961:	83 ec 04             	sub    $0x4,%esp
80105964:	ff 75 f0             	pushl  -0x10(%ebp)
80105967:	ff 75 f4             	pushl  -0xc(%ebp)
8010596a:	ff 75 ec             	pushl  -0x14(%ebp)
8010596d:	e8 ee b5 ff ff       	call   80100f60 <fileread>
80105972:	83 c4 10             	add    $0x10,%esp
}
80105975:	c9                   	leave  
80105976:	c3                   	ret    
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105990 <sys_write>:
{
80105990:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105991:	31 c0                	xor    %eax,%eax
{
80105993:	89 e5                	mov    %esp,%ebp
80105995:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105998:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010599b:	e8 c0 fe ff ff       	call   80105860 <argfd.constprop.0>
801059a0:	85 c0                	test   %eax,%eax
801059a2:	78 4c                	js     801059f0 <sys_write+0x60>
801059a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a7:	83 ec 08             	sub    $0x8,%esp
801059aa:	50                   	push   %eax
801059ab:	6a 02                	push   $0x2
801059ad:	e8 ae fb ff ff       	call   80105560 <argint>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 37                	js     801059f0 <sys_write+0x60>
801059b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059bc:	83 ec 04             	sub    $0x4,%esp
801059bf:	ff 75 f0             	pushl  -0x10(%ebp)
801059c2:	50                   	push   %eax
801059c3:	6a 01                	push   $0x1
801059c5:	e8 e6 fb ff ff       	call   801055b0 <argptr>
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	85 c0                	test   %eax,%eax
801059cf:	78 1f                	js     801059f0 <sys_write+0x60>
  return filewrite(f, p, n);
801059d1:	83 ec 04             	sub    $0x4,%esp
801059d4:	ff 75 f0             	pushl  -0x10(%ebp)
801059d7:	ff 75 f4             	pushl  -0xc(%ebp)
801059da:	ff 75 ec             	pushl  -0x14(%ebp)
801059dd:	e8 0e b6 ff ff       	call   80100ff0 <filewrite>
801059e2:	83 c4 10             	add    $0x10,%esp
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801059f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
801059f7:	89 f6                	mov    %esi,%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a00 <sys_close>:
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105a06:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105a09:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a0c:	e8 4f fe ff ff       	call   80105860 <argfd.constprop.0>
80105a11:	85 c0                	test   %eax,%eax
80105a13:	78 2b                	js     80105a40 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105a15:	e8 26 df ff ff       	call   80103940 <myproc>
80105a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105a20:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105a27:	00 
  fileclose(f);
80105a28:	ff 75 f4             	pushl  -0xc(%ebp)
80105a2b:	e8 10 b4 ff ff       	call   80100e40 <fileclose>
  return 0;
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	31 c0                	xor    %eax,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    
80105a47:	89 f6                	mov    %esi,%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a50 <sys_fstat>:
{
80105a50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a51:	31 c0                	xor    %eax,%eax
{
80105a53:	89 e5                	mov    %esp,%ebp
80105a55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a58:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105a5b:	e8 00 fe ff ff       	call   80105860 <argfd.constprop.0>
80105a60:	85 c0                	test   %eax,%eax
80105a62:	78 2c                	js     80105a90 <sys_fstat+0x40>
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a67:	83 ec 04             	sub    $0x4,%esp
80105a6a:	6a 14                	push   $0x14
80105a6c:	50                   	push   %eax
80105a6d:	6a 01                	push   $0x1
80105a6f:	e8 3c fb ff ff       	call   801055b0 <argptr>
80105a74:	83 c4 10             	add    $0x10,%esp
80105a77:	85 c0                	test   %eax,%eax
80105a79:	78 15                	js     80105a90 <sys_fstat+0x40>
  return filestat(f, st);
80105a7b:	83 ec 08             	sub    $0x8,%esp
80105a7e:	ff 75 f4             	pushl  -0xc(%ebp)
80105a81:	ff 75 f0             	pushl  -0x10(%ebp)
80105a84:	e8 87 b4 ff ff       	call   80100f10 <filestat>
80105a89:	83 c4 10             	add    $0x10,%esp
}
80105a8c:	c9                   	leave  
80105a8d:	c3                   	ret    
80105a8e:	66 90                	xchg   %ax,%ax
    return -1;
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <sys_link>:
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105aa6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105aa9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105aac:	50                   	push   %eax
80105aad:	6a 00                	push   $0x0
80105aaf:	e8 5c fb ff ff       	call   80105610 <argstr>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	85 c0                	test   %eax,%eax
80105ab9:	0f 88 fb 00 00 00    	js     80105bba <sys_link+0x11a>
80105abf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ac2:	83 ec 08             	sub    $0x8,%esp
80105ac5:	50                   	push   %eax
80105ac6:	6a 01                	push   $0x1
80105ac8:	e8 43 fb ff ff       	call   80105610 <argstr>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	0f 88 e2 00 00 00    	js     80105bba <sys_link+0x11a>
  begin_op();
80105ad8:	e8 d3 d0 ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	ff 75 d4             	pushl  -0x2c(%ebp)
80105ae3:	e8 08 c4 ff ff       	call   80101ef0 <namei>
80105ae8:	83 c4 10             	add    $0x10,%esp
80105aeb:	85 c0                	test   %eax,%eax
80105aed:	89 c3                	mov    %eax,%ebx
80105aef:	0f 84 ea 00 00 00    	je     80105bdf <sys_link+0x13f>
  ilock(ip);
80105af5:	83 ec 0c             	sub    $0xc,%esp
80105af8:	50                   	push   %eax
80105af9:	e8 92 bb ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b06:	0f 84 bb 00 00 00    	je     80105bc7 <sys_link+0x127>
  ip->nlink++;
80105b0c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b11:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105b14:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105b17:	53                   	push   %ebx
80105b18:	e8 c3 ba ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80105b1d:	89 1c 24             	mov    %ebx,(%esp)
80105b20:	e8 4b bc ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105b25:	58                   	pop    %eax
80105b26:	5a                   	pop    %edx
80105b27:	57                   	push   %edi
80105b28:	ff 75 d0             	pushl  -0x30(%ebp)
80105b2b:	e8 e0 c3 ff ff       	call   80101f10 <nameiparent>
80105b30:	83 c4 10             	add    $0x10,%esp
80105b33:	85 c0                	test   %eax,%eax
80105b35:	89 c6                	mov    %eax,%esi
80105b37:	74 5b                	je     80105b94 <sys_link+0xf4>
  ilock(dp);
80105b39:	83 ec 0c             	sub    $0xc,%esp
80105b3c:	50                   	push   %eax
80105b3d:	e8 4e bb ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b42:	83 c4 10             	add    $0x10,%esp
80105b45:	8b 03                	mov    (%ebx),%eax
80105b47:	39 06                	cmp    %eax,(%esi)
80105b49:	75 3d                	jne    80105b88 <sys_link+0xe8>
80105b4b:	83 ec 04             	sub    $0x4,%esp
80105b4e:	ff 73 04             	pushl  0x4(%ebx)
80105b51:	57                   	push   %edi
80105b52:	56                   	push   %esi
80105b53:	e8 d8 c2 ff ff       	call   80101e30 <dirlink>
80105b58:	83 c4 10             	add    $0x10,%esp
80105b5b:	85 c0                	test   %eax,%eax
80105b5d:	78 29                	js     80105b88 <sys_link+0xe8>
  iunlockput(dp);
80105b5f:	83 ec 0c             	sub    $0xc,%esp
80105b62:	56                   	push   %esi
80105b63:	e8 b8 bd ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105b68:	89 1c 24             	mov    %ebx,(%esp)
80105b6b:	e8 50 bc ff ff       	call   801017c0 <iput>
  end_op();
80105b70:	e8 ab d0 ff ff       	call   80102c20 <end_op>
  return 0;
80105b75:	83 c4 10             	add    $0x10,%esp
80105b78:	31 c0                	xor    %eax,%eax
}
80105b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b7d:	5b                   	pop    %ebx
80105b7e:	5e                   	pop    %esi
80105b7f:	5f                   	pop    %edi
80105b80:	5d                   	pop    %ebp
80105b81:	c3                   	ret    
80105b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	56                   	push   %esi
80105b8c:	e8 8f bd ff ff       	call   80101920 <iunlockput>
    goto bad;
80105b91:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105b94:	83 ec 0c             	sub    $0xc,%esp
80105b97:	53                   	push   %ebx
80105b98:	e8 f3 ba ff ff       	call   80101690 <ilock>
  ip->nlink--;
80105b9d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ba2:	89 1c 24             	mov    %ebx,(%esp)
80105ba5:	e8 36 ba ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80105baa:	89 1c 24             	mov    %ebx,(%esp)
80105bad:	e8 6e bd ff ff       	call   80101920 <iunlockput>
  end_op();
80105bb2:	e8 69 d0 ff ff       	call   80102c20 <end_op>
  return -1;
80105bb7:	83 c4 10             	add    $0x10,%esp
}
80105bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105bbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bc2:	5b                   	pop    %ebx
80105bc3:	5e                   	pop    %esi
80105bc4:	5f                   	pop    %edi
80105bc5:	5d                   	pop    %ebp
80105bc6:	c3                   	ret    
    iunlockput(ip);
80105bc7:	83 ec 0c             	sub    $0xc,%esp
80105bca:	53                   	push   %ebx
80105bcb:	e8 50 bd ff ff       	call   80101920 <iunlockput>
    end_op();
80105bd0:	e8 4b d0 ff ff       	call   80102c20 <end_op>
    return -1;
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bdd:	eb 9b                	jmp    80105b7a <sys_link+0xda>
    end_op();
80105bdf:	e8 3c d0 ff ff       	call   80102c20 <end_op>
    return -1;
80105be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be9:	eb 8f                	jmp    80105b7a <sys_link+0xda>
80105beb:	90                   	nop
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_unlink>:
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105bf6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105bf9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105bfc:	50                   	push   %eax
80105bfd:	6a 00                	push   $0x0
80105bff:	e8 0c fa ff ff       	call   80105610 <argstr>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
80105c09:	0f 88 77 01 00 00    	js     80105d86 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105c0f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105c12:	e8 99 cf ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c17:	83 ec 08             	sub    $0x8,%esp
80105c1a:	53                   	push   %ebx
80105c1b:	ff 75 c0             	pushl  -0x40(%ebp)
80105c1e:	e8 ed c2 ff ff       	call   80101f10 <nameiparent>
80105c23:	83 c4 10             	add    $0x10,%esp
80105c26:	85 c0                	test   %eax,%eax
80105c28:	89 c6                	mov    %eax,%esi
80105c2a:	0f 84 60 01 00 00    	je     80105d90 <sys_unlink+0x1a0>
  ilock(dp);
80105c30:	83 ec 0c             	sub    $0xc,%esp
80105c33:	50                   	push   %eax
80105c34:	e8 57 ba ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c39:	58                   	pop    %eax
80105c3a:	5a                   	pop    %edx
80105c3b:	68 74 89 10 80       	push   $0x80108974
80105c40:	53                   	push   %ebx
80105c41:	e8 5a bf ff ff       	call   80101ba0 <namecmp>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	0f 84 03 01 00 00    	je     80105d54 <sys_unlink+0x164>
80105c51:	83 ec 08             	sub    $0x8,%esp
80105c54:	68 73 89 10 80       	push   $0x80108973
80105c59:	53                   	push   %ebx
80105c5a:	e8 41 bf ff ff       	call   80101ba0 <namecmp>
80105c5f:	83 c4 10             	add    $0x10,%esp
80105c62:	85 c0                	test   %eax,%eax
80105c64:	0f 84 ea 00 00 00    	je     80105d54 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c6a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c6d:	83 ec 04             	sub    $0x4,%esp
80105c70:	50                   	push   %eax
80105c71:	53                   	push   %ebx
80105c72:	56                   	push   %esi
80105c73:	e8 48 bf ff ff       	call   80101bc0 <dirlookup>
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	85 c0                	test   %eax,%eax
80105c7d:	89 c3                	mov    %eax,%ebx
80105c7f:	0f 84 cf 00 00 00    	je     80105d54 <sys_unlink+0x164>
  ilock(ip);
80105c85:	83 ec 0c             	sub    $0xc,%esp
80105c88:	50                   	push   %eax
80105c89:	e8 02 ba ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c96:	0f 8e 10 01 00 00    	jle    80105dac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ca1:	74 6d                	je     80105d10 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105ca3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ca6:	83 ec 04             	sub    $0x4,%esp
80105ca9:	6a 10                	push   $0x10
80105cab:	6a 00                	push   $0x0
80105cad:	50                   	push   %eax
80105cae:	e8 ad f5 ff ff       	call   80105260 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cb3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105cb6:	6a 10                	push   $0x10
80105cb8:	ff 75 c4             	pushl  -0x3c(%ebp)
80105cbb:	50                   	push   %eax
80105cbc:	56                   	push   %esi
80105cbd:	e8 ae bd ff ff       	call   80101a70 <writei>
80105cc2:	83 c4 20             	add    $0x20,%esp
80105cc5:	83 f8 10             	cmp    $0x10,%eax
80105cc8:	0f 85 eb 00 00 00    	jne    80105db9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105cce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cd3:	0f 84 97 00 00 00    	je     80105d70 <sys_unlink+0x180>
  iunlockput(dp);
80105cd9:	83 ec 0c             	sub    $0xc,%esp
80105cdc:	56                   	push   %esi
80105cdd:	e8 3e bc ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105ce2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ce7:	89 1c 24             	mov    %ebx,(%esp)
80105cea:	e8 f1 b8 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80105cef:	89 1c 24             	mov    %ebx,(%esp)
80105cf2:	e8 29 bc ff ff       	call   80101920 <iunlockput>
  end_op();
80105cf7:	e8 24 cf ff ff       	call   80102c20 <end_op>
  return 0;
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	31 c0                	xor    %eax,%eax
}
80105d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d04:	5b                   	pop    %ebx
80105d05:	5e                   	pop    %esi
80105d06:	5f                   	pop    %edi
80105d07:	5d                   	pop    %ebp
80105d08:	c3                   	ret    
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d14:	76 8d                	jbe    80105ca3 <sys_unlink+0xb3>
80105d16:	bf 20 00 00 00       	mov    $0x20,%edi
80105d1b:	eb 0f                	jmp    80105d2c <sys_unlink+0x13c>
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
80105d20:	83 c7 10             	add    $0x10,%edi
80105d23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105d26:	0f 83 77 ff ff ff    	jae    80105ca3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d2c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d2f:	6a 10                	push   $0x10
80105d31:	57                   	push   %edi
80105d32:	50                   	push   %eax
80105d33:	53                   	push   %ebx
80105d34:	e8 37 bc ff ff       	call   80101970 <readi>
80105d39:	83 c4 10             	add    $0x10,%esp
80105d3c:	83 f8 10             	cmp    $0x10,%eax
80105d3f:	75 5e                	jne    80105d9f <sys_unlink+0x1af>
    if(de.inum != 0)
80105d41:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d46:	74 d8                	je     80105d20 <sys_unlink+0x130>
    iunlockput(ip);
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	53                   	push   %ebx
80105d4c:	e8 cf bb ff ff       	call   80101920 <iunlockput>
    goto bad;
80105d51:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105d54:	83 ec 0c             	sub    $0xc,%esp
80105d57:	56                   	push   %esi
80105d58:	e8 c3 bb ff ff       	call   80101920 <iunlockput>
  end_op();
80105d5d:	e8 be ce ff ff       	call   80102c20 <end_op>
  return -1;
80105d62:	83 c4 10             	add    $0x10,%esp
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6a:	eb 95                	jmp    80105d01 <sys_unlink+0x111>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105d70:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105d75:	83 ec 0c             	sub    $0xc,%esp
80105d78:	56                   	push   %esi
80105d79:	e8 62 b8 ff ff       	call   801015e0 <iupdate>
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	e9 53 ff ff ff       	jmp    80105cd9 <sys_unlink+0xe9>
    return -1;
80105d86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8b:	e9 71 ff ff ff       	jmp    80105d01 <sys_unlink+0x111>
    end_op();
80105d90:	e8 8b ce ff ff       	call   80102c20 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9a:	e9 62 ff ff ff       	jmp    80105d01 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105d9f:	83 ec 0c             	sub    $0xc,%esp
80105da2:	68 98 89 10 80       	push   $0x80108998
80105da7:	e8 e4 a5 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105dac:	83 ec 0c             	sub    $0xc,%esp
80105daf:	68 86 89 10 80       	push   $0x80108986
80105db4:	e8 d7 a5 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105db9:	83 ec 0c             	sub    $0xc,%esp
80105dbc:	68 aa 89 10 80       	push   $0x801089aa
80105dc1:	e8 ca a5 ff ff       	call   80100390 <panic>
80105dc6:	8d 76 00             	lea    0x0(%esi),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <sys_open>:

int
sys_open(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dd6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105dd9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ddc:	50                   	push   %eax
80105ddd:	6a 00                	push   $0x0
80105ddf:	e8 2c f8 ff ff       	call   80105610 <argstr>
80105de4:	83 c4 10             	add    $0x10,%esp
80105de7:	85 c0                	test   %eax,%eax
80105de9:	0f 88 1d 01 00 00    	js     80105f0c <sys_open+0x13c>
80105def:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df2:	83 ec 08             	sub    $0x8,%esp
80105df5:	50                   	push   %eax
80105df6:	6a 01                	push   $0x1
80105df8:	e8 63 f7 ff ff       	call   80105560 <argint>
80105dfd:	83 c4 10             	add    $0x10,%esp
80105e00:	85 c0                	test   %eax,%eax
80105e02:	0f 88 04 01 00 00    	js     80105f0c <sys_open+0x13c>
    return -1;

  begin_op();
80105e08:	e8 a3 cd ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
80105e0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e11:	0f 85 a9 00 00 00    	jne    80105ec0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105e17:	83 ec 0c             	sub    $0xc,%esp
80105e1a:	ff 75 e0             	pushl  -0x20(%ebp)
80105e1d:	e8 ce c0 ff ff       	call   80101ef0 <namei>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	89 c6                	mov    %eax,%esi
80105e29:	0f 84 b2 00 00 00    	je     80105ee1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	50                   	push   %eax
80105e33:	e8 58 b8 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e38:	83 c4 10             	add    $0x10,%esp
80105e3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e40:	0f 84 aa 00 00 00    	je     80105ef0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e46:	e8 35 af ff ff       	call   80100d80 <filealloc>
80105e4b:	85 c0                	test   %eax,%eax
80105e4d:	89 c7                	mov    %eax,%edi
80105e4f:	0f 84 a6 00 00 00    	je     80105efb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105e55:	e8 e6 da ff ff       	call   80103940 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e5a:	31 db                	xor    %ebx,%ebx
80105e5c:	eb 0e                	jmp    80105e6c <sys_open+0x9c>
80105e5e:	66 90                	xchg   %ax,%ax
80105e60:	83 c3 01             	add    $0x1,%ebx
80105e63:	83 fb 10             	cmp    $0x10,%ebx
80105e66:	0f 84 ac 00 00 00    	je     80105f18 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105e6c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e70:	85 d2                	test   %edx,%edx
80105e72:	75 ec                	jne    80105e60 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e74:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e77:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105e7b:	56                   	push   %esi
80105e7c:	e8 ef b8 ff ff       	call   80101770 <iunlock>
  end_op();
80105e81:	e8 9a cd ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105e86:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e8f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e92:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e95:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e9c:	89 d0                	mov    %edx,%eax
80105e9e:	f7 d0                	not    %eax
80105ea0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ea3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ea6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ea9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eb0:	89 d8                	mov    %ebx,%eax
80105eb2:	5b                   	pop    %ebx
80105eb3:	5e                   	pop    %esi
80105eb4:	5f                   	pop    %edi
80105eb5:	5d                   	pop    %ebp
80105eb6:	c3                   	ret    
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ec6:	31 c9                	xor    %ecx,%ecx
80105ec8:	6a 00                	push   $0x0
80105eca:	ba 02 00 00 00       	mov    $0x2,%edx
80105ecf:	e8 ec f7 ff ff       	call   801056c0 <create>
    if(ip == 0){
80105ed4:	83 c4 10             	add    $0x10,%esp
80105ed7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105ed9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105edb:	0f 85 65 ff ff ff    	jne    80105e46 <sys_open+0x76>
      end_op();
80105ee1:	e8 3a cd ff ff       	call   80102c20 <end_op>
      return -1;
80105ee6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105eeb:	eb c0                	jmp    80105ead <sys_open+0xdd>
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ef0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ef3:	85 c9                	test   %ecx,%ecx
80105ef5:	0f 84 4b ff ff ff    	je     80105e46 <sys_open+0x76>
    iunlockput(ip);
80105efb:	83 ec 0c             	sub    $0xc,%esp
80105efe:	56                   	push   %esi
80105eff:	e8 1c ba ff ff       	call   80101920 <iunlockput>
    end_op();
80105f04:	e8 17 cd ff ff       	call   80102c20 <end_op>
    return -1;
80105f09:	83 c4 10             	add    $0x10,%esp
80105f0c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f11:	eb 9a                	jmp    80105ead <sys_open+0xdd>
80105f13:	90                   	nop
80105f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105f18:	83 ec 0c             	sub    $0xc,%esp
80105f1b:	57                   	push   %edi
80105f1c:	e8 1f af ff ff       	call   80100e40 <fileclose>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	eb d5                	jmp    80105efb <sys_open+0x12b>
80105f26:	8d 76 00             	lea    0x0(%esi),%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f36:	e8 75 cc ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f3e:	83 ec 08             	sub    $0x8,%esp
80105f41:	50                   	push   %eax
80105f42:	6a 00                	push   $0x0
80105f44:	e8 c7 f6 ff ff       	call   80105610 <argstr>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	78 30                	js     80105f80 <sys_mkdir+0x50>
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f56:	31 c9                	xor    %ecx,%ecx
80105f58:	6a 00                	push   $0x0
80105f5a:	ba 01 00 00 00       	mov    $0x1,%edx
80105f5f:	e8 5c f7 ff ff       	call   801056c0 <create>
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	85 c0                	test   %eax,%eax
80105f69:	74 15                	je     80105f80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f6b:	83 ec 0c             	sub    $0xc,%esp
80105f6e:	50                   	push   %eax
80105f6f:	e8 ac b9 ff ff       	call   80101920 <iunlockput>
  end_op();
80105f74:	e8 a7 cc ff ff       	call   80102c20 <end_op>
  return 0;
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	31 c0                	xor    %eax,%eax
}
80105f7e:	c9                   	leave  
80105f7f:	c3                   	ret    
    end_op();
80105f80:	e8 9b cc ff ff       	call   80102c20 <end_op>
    return -1;
80105f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f8a:	c9                   	leave  
80105f8b:	c3                   	ret    
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_mknod>:

int
sys_mknod(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f96:	e8 15 cc ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f9e:	83 ec 08             	sub    $0x8,%esp
80105fa1:	50                   	push   %eax
80105fa2:	6a 00                	push   $0x0
80105fa4:	e8 67 f6 ff ff       	call   80105610 <argstr>
80105fa9:	83 c4 10             	add    $0x10,%esp
80105fac:	85 c0                	test   %eax,%eax
80105fae:	78 60                	js     80106010 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105fb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb3:	83 ec 08             	sub    $0x8,%esp
80105fb6:	50                   	push   %eax
80105fb7:	6a 01                	push   $0x1
80105fb9:	e8 a2 f5 ff ff       	call   80105560 <argint>
  if((argstr(0, &path)) < 0 ||
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	85 c0                	test   %eax,%eax
80105fc3:	78 4b                	js     80106010 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc8:	83 ec 08             	sub    $0x8,%esp
80105fcb:	50                   	push   %eax
80105fcc:	6a 02                	push   $0x2
80105fce:	e8 8d f5 ff ff       	call   80105560 <argint>
     argint(1, &major) < 0 ||
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 c0                	test   %eax,%eax
80105fd8:	78 36                	js     80106010 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fda:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105fde:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fe1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105fe5:	ba 03 00 00 00       	mov    $0x3,%edx
80105fea:	50                   	push   %eax
80105feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fee:	e8 cd f6 ff ff       	call   801056c0 <create>
80105ff3:	83 c4 10             	add    $0x10,%esp
80105ff6:	85 c0                	test   %eax,%eax
80105ff8:	74 16                	je     80106010 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	50                   	push   %eax
80105ffe:	e8 1d b9 ff ff       	call   80101920 <iunlockput>
  end_op();
80106003:	e8 18 cc ff ff       	call   80102c20 <end_op>
  return 0;
80106008:	83 c4 10             	add    $0x10,%esp
8010600b:	31 c0                	xor    %eax,%eax
}
8010600d:	c9                   	leave  
8010600e:	c3                   	ret    
8010600f:	90                   	nop
    end_op();
80106010:	e8 0b cc ff ff       	call   80102c20 <end_op>
    return -1;
80106015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601a:	c9                   	leave  
8010601b:	c3                   	ret    
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_chdir>:

int
sys_chdir(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	56                   	push   %esi
80106024:	53                   	push   %ebx
80106025:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106028:	e8 13 d9 ff ff       	call   80103940 <myproc>
8010602d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010602f:	e8 7c cb ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106034:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106037:	83 ec 08             	sub    $0x8,%esp
8010603a:	50                   	push   %eax
8010603b:	6a 00                	push   $0x0
8010603d:	e8 ce f5 ff ff       	call   80105610 <argstr>
80106042:	83 c4 10             	add    $0x10,%esp
80106045:	85 c0                	test   %eax,%eax
80106047:	78 77                	js     801060c0 <sys_chdir+0xa0>
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	ff 75 f4             	pushl  -0xc(%ebp)
8010604f:	e8 9c be ff ff       	call   80101ef0 <namei>
80106054:	83 c4 10             	add    $0x10,%esp
80106057:	85 c0                	test   %eax,%eax
80106059:	89 c3                	mov    %eax,%ebx
8010605b:	74 63                	je     801060c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	50                   	push   %eax
80106061:	e8 2a b6 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80106066:	83 c4 10             	add    $0x10,%esp
80106069:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010606e:	75 30                	jne    801060a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	53                   	push   %ebx
80106074:	e8 f7 b6 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80106079:	58                   	pop    %eax
8010607a:	ff 76 68             	pushl  0x68(%esi)
8010607d:	e8 3e b7 ff ff       	call   801017c0 <iput>
  end_op();
80106082:	e8 99 cb ff ff       	call   80102c20 <end_op>
  curproc->cwd = ip;
80106087:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	31 c0                	xor    %eax,%eax
}
8010608f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106092:	5b                   	pop    %ebx
80106093:	5e                   	pop    %esi
80106094:	5d                   	pop    %ebp
80106095:	c3                   	ret    
80106096:	8d 76 00             	lea    0x0(%esi),%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	53                   	push   %ebx
801060a4:	e8 77 b8 ff ff       	call   80101920 <iunlockput>
    end_op();
801060a9:	e8 72 cb ff ff       	call   80102c20 <end_op>
    return -1;
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b6:	eb d7                	jmp    8010608f <sys_chdir+0x6f>
801060b8:	90                   	nop
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801060c0:	e8 5b cb ff ff       	call   80102c20 <end_op>
    return -1;
801060c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ca:	eb c3                	jmp    8010608f <sys_chdir+0x6f>
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_exec>:

int
sys_exec(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	57                   	push   %edi
801060d4:	56                   	push   %esi
801060d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801060dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060e2:	50                   	push   %eax
801060e3:	6a 00                	push   $0x0
801060e5:	e8 26 f5 ff ff       	call   80105610 <argstr>
801060ea:	83 c4 10             	add    $0x10,%esp
801060ed:	85 c0                	test   %eax,%eax
801060ef:	0f 88 87 00 00 00    	js     8010617c <sys_exec+0xac>
801060f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801060fb:	83 ec 08             	sub    $0x8,%esp
801060fe:	50                   	push   %eax
801060ff:	6a 01                	push   $0x1
80106101:	e8 5a f4 ff ff       	call   80105560 <argint>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	85 c0                	test   %eax,%eax
8010610b:	78 6f                	js     8010617c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010610d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106113:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106116:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106118:	68 80 00 00 00       	push   $0x80
8010611d:	6a 00                	push   $0x0
8010611f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106125:	50                   	push   %eax
80106126:	e8 35 f1 ff ff       	call   80105260 <memset>
8010612b:	83 c4 10             	add    $0x10,%esp
8010612e:	eb 2c                	jmp    8010615c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106130:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106136:	85 c0                	test   %eax,%eax
80106138:	74 56                	je     80106190 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010613a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106140:	83 ec 08             	sub    $0x8,%esp
80106143:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106146:	52                   	push   %edx
80106147:	50                   	push   %eax
80106148:	e8 a3 f3 ff ff       	call   801054f0 <fetchstr>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	78 28                	js     8010617c <sys_exec+0xac>
  for(i=0;; i++){
80106154:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106157:	83 fb 20             	cmp    $0x20,%ebx
8010615a:	74 20                	je     8010617c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010615c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106162:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106169:	83 ec 08             	sub    $0x8,%esp
8010616c:	57                   	push   %edi
8010616d:	01 f0                	add    %esi,%eax
8010616f:	50                   	push   %eax
80106170:	e8 3b f3 ff ff       	call   801054b0 <fetchint>
80106175:	83 c4 10             	add    $0x10,%esp
80106178:	85 c0                	test   %eax,%eax
8010617a:	79 b4                	jns    80106130 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010617c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010617f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106184:	5b                   	pop    %ebx
80106185:	5e                   	pop    %esi
80106186:	5f                   	pop    %edi
80106187:	5d                   	pop    %ebp
80106188:	c3                   	ret    
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106190:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106196:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106199:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801061a0:	00 00 00 00 
  return exec(path, argv);
801061a4:	50                   	push   %eax
801061a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801061ab:	e8 60 a8 ff ff       	call   80100a10 <exec>
801061b0:	83 c4 10             	add    $0x10,%esp
}
801061b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b6:	5b                   	pop    %ebx
801061b7:	5e                   	pop    %esi
801061b8:	5f                   	pop    %edi
801061b9:	5d                   	pop    %ebp
801061ba:	c3                   	ret    
801061bb:	90                   	nop
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061c0 <sys_pipe>:

int
sys_pipe(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	57                   	push   %edi
801061c4:	56                   	push   %esi
801061c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801061c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061cc:	6a 08                	push   $0x8
801061ce:	50                   	push   %eax
801061cf:	6a 00                	push   $0x0
801061d1:	e8 da f3 ff ff       	call   801055b0 <argptr>
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	85 c0                	test   %eax,%eax
801061db:	0f 88 ae 00 00 00    	js     8010628f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801061e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061e4:	83 ec 08             	sub    $0x8,%esp
801061e7:	50                   	push   %eax
801061e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061eb:	50                   	push   %eax
801061ec:	e8 5f d0 ff ff       	call   80103250 <pipealloc>
801061f1:	83 c4 10             	add    $0x10,%esp
801061f4:	85 c0                	test   %eax,%eax
801061f6:	0f 88 93 00 00 00    	js     8010628f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801061ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106201:	e8 3a d7 ff ff       	call   80103940 <myproc>
80106206:	eb 10                	jmp    80106218 <sys_pipe+0x58>
80106208:	90                   	nop
80106209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106210:	83 c3 01             	add    $0x1,%ebx
80106213:	83 fb 10             	cmp    $0x10,%ebx
80106216:	74 60                	je     80106278 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106218:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010621c:	85 f6                	test   %esi,%esi
8010621e:	75 f0                	jne    80106210 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106220:	8d 73 08             	lea    0x8(%ebx),%esi
80106223:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106227:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010622a:	e8 11 d7 ff ff       	call   80103940 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010622f:	31 d2                	xor    %edx,%edx
80106231:	eb 0d                	jmp    80106240 <sys_pipe+0x80>
80106233:	90                   	nop
80106234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106238:	83 c2 01             	add    $0x1,%edx
8010623b:	83 fa 10             	cmp    $0x10,%edx
8010623e:	74 28                	je     80106268 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106240:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106244:	85 c9                	test   %ecx,%ecx
80106246:	75 f0                	jne    80106238 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106248:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010624c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010624f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106251:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106254:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106257:	31 c0                	xor    %eax,%eax
}
80106259:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010625c:	5b                   	pop    %ebx
8010625d:	5e                   	pop    %esi
8010625e:	5f                   	pop    %edi
8010625f:	5d                   	pop    %ebp
80106260:	c3                   	ret    
80106261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106268:	e8 d3 d6 ff ff       	call   80103940 <myproc>
8010626d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106274:	00 
80106275:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106278:	83 ec 0c             	sub    $0xc,%esp
8010627b:	ff 75 e0             	pushl  -0x20(%ebp)
8010627e:	e8 bd ab ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106283:	58                   	pop    %eax
80106284:	ff 75 e4             	pushl  -0x1c(%ebp)
80106287:	e8 b4 ab ff ff       	call   80100e40 <fileclose>
    return -1;
8010628c:	83 c4 10             	add    $0x10,%esp
8010628f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106294:	eb c3                	jmp    80106259 <sys_pipe+0x99>
80106296:	66 90                	xchg   %ax,%ax
80106298:	66 90                	xchg   %ax,%ax
8010629a:	66 90                	xchg   %ax,%ax
8010629c:	66 90                	xchg   %ax,%ax
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801062a3:	5d                   	pop    %ebp
  return fork();
801062a4:	e9 37 d8 ff ff       	jmp    80103ae0 <fork>
801062a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062b0 <sys_exit>:

int
sys_exit(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801062b6:	e8 a5 da ff ff       	call   80103d60 <exit>
  return 0;  // not reached
}
801062bb:	31 c0                	xor    %eax,%eax
801062bd:	c9                   	leave  
801062be:	c3                   	ret    
801062bf:	90                   	nop

801062c0 <sys_wait>:

int
sys_wait(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801062c3:	5d                   	pop    %ebp
  return wait();
801062c4:	e9 d7 dc ff ff       	jmp    80103fa0 <wait>
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_kill>:

int
sys_kill(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062d9:	50                   	push   %eax
801062da:	6a 00                	push   $0x0
801062dc:	e8 7f f2 ff ff       	call   80105560 <argint>
801062e1:	83 c4 10             	add    $0x10,%esp
801062e4:	85 c0                	test   %eax,%eax
801062e6:	78 18                	js     80106300 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	ff 75 f4             	pushl  -0xc(%ebp)
801062ee:	e8 0d de ff ff       	call   80104100 <kill>
801062f3:	83 c4 10             	add    $0x10,%esp
}
801062f6:	c9                   	leave  
801062f7:	c3                   	ret    
801062f8:	90                   	nop
801062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106305:	c9                   	leave  
80106306:	c3                   	ret    
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106310 <sys_getpid>:

int
sys_getpid(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106316:	e8 25 d6 ff ff       	call   80103940 <myproc>
8010631b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010631e:	c9                   	leave  
8010631f:	c3                   	ret    

80106320 <sys_sbrk>:

int
sys_sbrk(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106324:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106327:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010632a:	50                   	push   %eax
8010632b:	6a 00                	push   $0x0
8010632d:	e8 2e f2 ff ff       	call   80105560 <argint>
80106332:	83 c4 10             	add    $0x10,%esp
80106335:	85 c0                	test   %eax,%eax
80106337:	78 27                	js     80106360 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106339:	e8 02 d6 ff ff       	call   80103940 <myproc>
  if(growproc(n) < 0)
8010633e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106341:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106343:	ff 75 f4             	pushl  -0xc(%ebp)
80106346:	e8 15 d7 ff ff       	call   80103a60 <growproc>
8010634b:	83 c4 10             	add    $0x10,%esp
8010634e:	85 c0                	test   %eax,%eax
80106350:	78 0e                	js     80106360 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106352:	89 d8                	mov    %ebx,%eax
80106354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106357:	c9                   	leave  
80106358:	c3                   	ret    
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106360:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106365:	eb eb                	jmp    80106352 <sys_sbrk+0x32>
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106370 <sys_sleep>:

int
sys_sleep(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106374:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106377:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010637a:	50                   	push   %eax
8010637b:	6a 00                	push   $0x0
8010637d:	e8 de f1 ff ff       	call   80105560 <argint>
80106382:	83 c4 10             	add    $0x10,%esp
80106385:	85 c0                	test   %eax,%eax
80106387:	0f 88 8a 00 00 00    	js     80106417 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010638d:	83 ec 0c             	sub    $0xc,%esp
80106390:	68 a0 31 13 80       	push   $0x801331a0
80106395:	e8 b6 ed ff ff       	call   80105150 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010639a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010639d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801063a0:	8b 1d e0 39 13 80    	mov    0x801339e0,%ebx
  while(ticks - ticks0 < n){
801063a6:	85 d2                	test   %edx,%edx
801063a8:	75 27                	jne    801063d1 <sys_sleep+0x61>
801063aa:	eb 54                	jmp    80106400 <sys_sleep+0x90>
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801063b0:	83 ec 08             	sub    $0x8,%esp
801063b3:	68 a0 31 13 80       	push   $0x801331a0
801063b8:	68 e0 39 13 80       	push   $0x801339e0
801063bd:	e8 1e db ff ff       	call   80103ee0 <sleep>
  while(ticks - ticks0 < n){
801063c2:	a1 e0 39 13 80       	mov    0x801339e0,%eax
801063c7:	83 c4 10             	add    $0x10,%esp
801063ca:	29 d8                	sub    %ebx,%eax
801063cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801063cf:	73 2f                	jae    80106400 <sys_sleep+0x90>
    if(myproc()->killed){
801063d1:	e8 6a d5 ff ff       	call   80103940 <myproc>
801063d6:	8b 40 24             	mov    0x24(%eax),%eax
801063d9:	85 c0                	test   %eax,%eax
801063db:	74 d3                	je     801063b0 <sys_sleep+0x40>
      release(&tickslock);
801063dd:	83 ec 0c             	sub    $0xc,%esp
801063e0:	68 a0 31 13 80       	push   $0x801331a0
801063e5:	e8 26 ee ff ff       	call   80105210 <release>
      return -1;
801063ea:	83 c4 10             	add    $0x10,%esp
801063ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801063f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    
801063f7:	89 f6                	mov    %esi,%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106400:	83 ec 0c             	sub    $0xc,%esp
80106403:	68 a0 31 13 80       	push   $0x801331a0
80106408:	e8 03 ee ff ff       	call   80105210 <release>
  return 0;
8010640d:	83 c4 10             	add    $0x10,%esp
80106410:	31 c0                	xor    %eax,%eax
}
80106412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106415:	c9                   	leave  
80106416:	c3                   	ret    
    return -1;
80106417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010641c:	eb f4                	jmp    80106412 <sys_sleep+0xa2>
8010641e:	66 90                	xchg   %ax,%ax

80106420 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	53                   	push   %ebx
80106424:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106427:	68 a0 31 13 80       	push   $0x801331a0
8010642c:	e8 1f ed ff ff       	call   80105150 <acquire>
  xticks = ticks;
80106431:	8b 1d e0 39 13 80    	mov    0x801339e0,%ebx
  release(&tickslock);
80106437:	c7 04 24 a0 31 13 80 	movl   $0x801331a0,(%esp)
8010643e:	e8 cd ed ff ff       	call   80105210 <release>
  return xticks;
}
80106443:	89 d8                	mov    %ebx,%eax
80106445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106448:	c9                   	leave  
80106449:	c3                   	ret    
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106450 <sys_halt>:

int 
sys_halt(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	83 ec 08             	sub    $0x8,%esp
  halt();
80106456:	e8 f5 dd ff ff       	call   80104250 <halt>
  cprintf("Command for shutdown\n");
8010645b:	83 ec 0c             	sub    $0xc,%esp
8010645e:	68 b9 89 10 80       	push   $0x801089b9
80106463:	e8 f8 a1 ff ff       	call   80100660 <cprintf>
  return 0;
}
80106468:	31 c0                	xor    %eax,%eax
8010646a:	c9                   	leave  
8010646b:	c3                   	ret    
8010646c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106470 <sys_toggle>:

int
sys_toggle(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 08             	sub    $0x8,%esp
  // cprintf("in sys_toggle\n");
  toggle();
80106476:	e8 f5 dd ff ff       	call   80104270 <toggle>
  return 0;
}
8010647b:	31 c0                	xor    %eax,%eax
8010647d:	c9                   	leave  
8010647e:	c3                   	ret    
8010647f:	90                   	nop

80106480 <sys_print_count>:

int
sys_print_count(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	83 ec 08             	sub    $0x8,%esp
  // cprintf("in sys_print_count\n");
  print_count();
80106486:	e8 45 de ff ff       	call   801042d0 <print_count>
  return 0;
}
8010648b:	31 c0                	xor    %eax,%eax
8010648d:	c9                   	leave  
8010648e:	c3                   	ret    
8010648f:	90                   	nop

80106490 <sys_ps>:

int 
sys_ps(void)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	83 ec 08             	sub    $0x8,%esp
  ps();
80106496:	e8 a5 de ff ff       	call   80104340 <ps>
  return 0;
}
8010649b:	31 c0                	xor    %eax,%eax
8010649d:	c9                   	leave  
8010649e:	c3                   	ret    
8010649f:	90                   	nop

801064a0 <sys_send>:

int 
sys_send(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	83 ec 20             	sub    $0x20,%esp
  int a,b;
  char* msg;
  if(argint(0, &a) < 0)
801064a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064a9:	50                   	push   %eax
801064aa:	6a 00                	push   $0x0
801064ac:	e8 af f0 ff ff       	call   80105560 <argint>
801064b1:	83 c4 10             	add    $0x10,%esp
801064b4:	85 c0                	test   %eax,%eax
801064b6:	78 48                	js     80106500 <sys_send+0x60>
    return -1;
  if(argint(1, &b) < 0)
801064b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064bb:	83 ec 08             	sub    $0x8,%esp
801064be:	50                   	push   %eax
801064bf:	6a 01                	push   $0x1
801064c1:	e8 9a f0 ff ff       	call   80105560 <argint>
801064c6:	83 c4 10             	add    $0x10,%esp
801064c9:	85 c0                	test   %eax,%eax
801064cb:	78 33                	js     80106500 <sys_send+0x60>
    return -1;
  if(argptr(2, &msg, MSGSIZE) < 0)
801064cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064d0:	83 ec 04             	sub    $0x4,%esp
801064d3:	6a 08                	push   $0x8
801064d5:	50                   	push   %eax
801064d6:	6a 02                	push   $0x2
801064d8:	e8 d3 f0 ff ff       	call   801055b0 <argptr>
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	85 c0                	test   %eax,%eax
801064e2:	78 1c                	js     80106500 <sys_send+0x60>
    return -1;
  send(a,b,msg);
801064e4:	83 ec 04             	sub    $0x4,%esp
801064e7:	ff 75 f4             	pushl  -0xc(%ebp)
801064ea:	ff 75 f0             	pushl  -0x10(%ebp)
801064ed:	ff 75 ec             	pushl  -0x14(%ebp)
801064f0:	e8 1b df ff ff       	call   80104410 <send>
  return 0;
801064f5:	83 c4 10             	add    $0x10,%esp
801064f8:	31 c0                	xor    %eax,%eax
}
801064fa:	c9                   	leave  
801064fb:	c3                   	ret    
801064fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106505:	c9                   	leave  
80106506:	c3                   	ret    
80106507:	89 f6                	mov    %esi,%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106510 <sys_recv>:

int 
sys_recv(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 1c             	sub    $0x1c,%esp
  char* msg;
  if(argptr(0, &msg, MSGSIZE) < 0)
80106516:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106519:	6a 08                	push   $0x8
8010651b:	50                   	push   %eax
8010651c:	6a 00                	push   $0x0
8010651e:	e8 8d f0 ff ff       	call   801055b0 <argptr>
80106523:	83 c4 10             	add    $0x10,%esp
80106526:	85 c0                	test   %eax,%eax
80106528:	78 16                	js     80106540 <sys_recv+0x30>
    return -1;
  // int ret = recv(msg);
  // cprintf("msg in sysproc: %s\n",msg);
  // cprintf("ret value: %d\n",ret);

  return recv(msg);
8010652a:	83 ec 0c             	sub    $0xc,%esp
8010652d:	ff 75 f4             	pushl  -0xc(%ebp)
80106530:	e8 9b e0 ff ff       	call   801045d0 <recv>
80106535:	83 c4 10             	add    $0x10,%esp
  
}
80106538:	c9                   	leave  
80106539:	c3                   	ret    
8010653a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106545:	c9                   	leave  
80106546:	c3                   	ret    
80106547:	89 f6                	mov    %esi,%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106550 <sys_send_multi>:

int 
sys_send_multi(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	57                   	push   %edi
80106554:	56                   	push   %esi
80106555:	53                   	push   %ebx
  // cprintf("in sysproc");

  int a,len,b;
  char* msg;
  if(argint(0, &a) < 0)
80106556:	8d 45 d8             	lea    -0x28(%ebp),%eax
{
80106559:	83 ec 24             	sub    $0x24,%esp
  if(argint(0, &a) < 0)
8010655c:	50                   	push   %eax
8010655d:	6a 00                	push   $0x0
8010655f:	e8 fc ef ff ff       	call   80105560 <argint>
80106564:	83 c4 10             	add    $0x10,%esp
80106567:	85 c0                	test   %eax,%eax
80106569:	0f 88 91 00 00 00    	js     80106600 <sys_send_multi+0xb0>
    return -1;
  if(argint(3, &len) < 0)
8010656f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106572:	83 ec 08             	sub    $0x8,%esp
80106575:	50                   	push   %eax
80106576:	6a 03                	push   $0x3
80106578:	e8 e3 ef ff ff       	call   80105560 <argint>
8010657d:	83 c4 10             	add    $0x10,%esp
80106580:	85 c0                	test   %eax,%eax
80106582:	78 7c                	js     80106600 <sys_send_multi+0xb0>
    return -1;
  if(argptr(2, &msg, MSGSIZE) < 0)
80106584:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106587:	83 ec 04             	sub    $0x4,%esp
8010658a:	6a 08                	push   $0x8
8010658c:	50                   	push   %eax
8010658d:	6a 02                	push   $0x2
8010658f:	e8 1c f0 ff ff       	call   801055b0 <argptr>
80106594:	83 c4 10             	add    $0x10,%esp
80106597:	85 c0                	test   %eax,%eax
80106599:	78 65                	js     80106600 <sys_send_multi+0xb0>
    return -1;
  if(argint(1, &b) < 0)
8010659b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010659e:	83 ec 08             	sub    $0x8,%esp
801065a1:	50                   	push   %eax
801065a2:	6a 01                	push   $0x1
801065a4:	e8 b7 ef ff ff       	call   80105560 <argint>
801065a9:	83 c4 10             	add    $0x10,%esp
801065ac:	85 c0                	test   %eax,%eax
801065ae:	78 50                	js     80106600 <sys_send_multi+0xb0>
    return -1;
  // cprintf("len in sysproc: %d\n",len);
  // cprintf("printing the array in sysproc: \n");
  int* d;
  d = (int*)b;
  int arr[len];
801065b0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  d = (int*)b;
801065b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  int arr[len];
801065b6:	8d 14 9d 12 00 00 00 	lea    0x12(,%ebx,4),%edx
801065bd:	83 e2 f0             	and    $0xfffffff0,%edx
801065c0:	29 d4                	sub    %edx,%esp
  for(int i=0;i<len;i++)
801065c2:	85 db                	test   %ebx,%ebx
  int arr[len];
801065c4:	89 e7                	mov    %esp,%edi
  for(int i=0;i<len;i++)
801065c6:	7e 18                	jle    801065e0 <sys_send_multi+0x90>
  {
    arr[i] = *d;
801065c8:	89 fe                	mov    %edi,%esi
  for(int i=0;i<len;i++)
801065ca:	31 d2                	xor    %edx,%edx
    arr[i] = *d;
801065cc:	29 c6                	sub    %eax,%esi
801065ce:	66 90                	xchg   %ax,%ax
801065d0:	8b 08                	mov    (%eax),%ecx
  for(int i=0;i<len;i++)
801065d2:	83 c2 01             	add    $0x1,%edx
    // cprintf("%d\n",arr[i]);
    d++;
801065d5:	83 c0 04             	add    $0x4,%eax
    arr[i] = *d;
801065d8:	89 4c 30 fc          	mov    %ecx,-0x4(%eax,%esi,1)
  for(int i=0;i<len;i++)
801065dc:	39 d3                	cmp    %edx,%ebx
801065de:	75 f0                	jne    801065d0 <sys_send_multi+0x80>
  }
  send_multi(a,arr,msg,len);
801065e0:	53                   	push   %ebx
801065e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801065e4:	57                   	push   %edi
801065e5:	ff 75 d8             	pushl  -0x28(%ebp)
801065e8:	e8 e3 e0 ff ff       	call   801046d0 <send_multi>
  return 0;
801065ed:	83 c4 10             	add    $0x10,%esp
801065f0:	31 c0                	xor    %eax,%eax
}
801065f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f5:	5b                   	pop    %ebx
801065f6:	5e                   	pop    %esi
801065f7:	5f                   	pop    %edi
801065f8:	5d                   	pop    %ebp
801065f9:	c3                   	ret    
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106605:	eb eb                	jmp    801065f2 <sys_send_multi+0xa2>
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <sys_store>:

int 
sys_store(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 20             	sub    $0x20,%esp
  int a,b;
  if(argint(0, &a) < 0)
80106616:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106619:	50                   	push   %eax
8010661a:	6a 00                	push   $0x0
8010661c:	e8 3f ef ff ff       	call   80105560 <argint>
80106621:	83 c4 10             	add    $0x10,%esp
80106624:	85 c0                	test   %eax,%eax
80106626:	78 30                	js     80106658 <sys_store+0x48>
    return -1;
  if(argint(1, &b) < 0)
80106628:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010662b:	83 ec 08             	sub    $0x8,%esp
8010662e:	50                   	push   %eax
8010662f:	6a 01                	push   $0x1
80106631:	e8 2a ef ff ff       	call   80105560 <argint>
80106636:	83 c4 10             	add    $0x10,%esp
80106639:	85 c0                	test   %eax,%eax
8010663b:	78 1b                	js     80106658 <sys_store+0x48>
    return -1;
  store(a,b);
8010663d:	83 ec 08             	sub    $0x8,%esp
80106640:	ff 75 f4             	pushl  -0xc(%ebp)
80106643:	ff 75 f0             	pushl  -0x10(%ebp)
80106646:	e8 55 e1 ff ff       	call   801047a0 <store>
  return 0;
8010664b:	83 c4 10             	add    $0x10,%esp
8010664e:	31 c0                	xor    %eax,%eax
}
80106650:	c9                   	leave  
80106651:	c3                   	ret    
80106652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010665d:	c9                   	leave  
8010665e:	c3                   	ret    
8010665f:	90                   	nop

80106660 <sys_sleepcustom>:

int 
sys_sleepcustom(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 20             	sub    $0x20,%esp
  int a;
  if(argint(0, &a) < 0)
80106666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106669:	50                   	push   %eax
8010666a:	6a 00                	push   $0x0
8010666c:	e8 ef ee ff ff       	call   80105560 <argint>
80106671:	83 c4 10             	add    $0x10,%esp
80106674:	85 c0                	test   %eax,%eax
80106676:	78 18                	js     80106690 <sys_sleepcustom+0x30>
    return -1;
  sleepcustom(a);
80106678:	83 ec 0c             	sub    $0xc,%esp
8010667b:	ff 75 f4             	pushl  -0xc(%ebp)
8010667e:	e8 4d e1 ff ff       	call   801047d0 <sleepcustom>
  return 0;
80106683:	83 c4 10             	add    $0x10,%esp
80106686:	31 c0                	xor    %eax,%eax
}
80106688:	c9                   	leave  
80106689:	c3                   	ret    
8010668a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106695:	c9                   	leave  
80106696:	c3                   	ret    
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <sys_wakeupcustom>:

int 
sys_wakeupcustom(void)
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	83 ec 20             	sub    $0x20,%esp
  int a;
  if(argint(0, &a) < 0)
801066a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066a9:	50                   	push   %eax
801066aa:	6a 00                	push   $0x0
801066ac:	e8 af ee ff ff       	call   80105560 <argint>
801066b1:	83 c4 10             	add    $0x10,%esp
801066b4:	85 c0                	test   %eax,%eax
801066b6:	78 18                	js     801066d0 <sys_wakeupcustom+0x30>
    return -1;
  wakeupcustom(a);
801066b8:	83 ec 0c             	sub    $0xc,%esp
801066bb:	ff 75 f4             	pushl  -0xc(%ebp)
801066be:	e8 6d e1 ff ff       	call   80104830 <wakeupcustom>
  return 0;
801066c3:	83 c4 10             	add    $0x10,%esp
801066c6:	31 c0                	xor    %eax,%eax
}
801066c8:	c9                   	leave  
801066c9:	c3                   	ret    
801066ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801066d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066d5:	c9                   	leave  
801066d6:	c3                   	ret    
801066d7:	89 f6                	mov    %esi,%esi
801066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066e0 <sys_read_mean>:


int 
sys_read_mean(void)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	83 ec 1c             	sub    $0x1c,%esp
  char* msg;
  if(argptr(0, &msg, MSGSIZE) < 0)
801066e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066e9:	6a 08                	push   $0x8
801066eb:	50                   	push   %eax
801066ec:	6a 00                	push   $0x0
801066ee:	e8 bd ee ff ff       	call   801055b0 <argptr>
801066f3:	83 c4 10             	add    $0x10,%esp
801066f6:	85 c0                	test   %eax,%eax
801066f8:	78 16                	js     80106710 <sys_read_mean+0x30>
    return -1;
  return read_mean(msg);
801066fa:	83 ec 0c             	sub    $0xc,%esp
801066fd:	ff 75 f4             	pushl  -0xc(%ebp)
80106700:	e8 8b e1 ff ff       	call   80104890 <read_mean>
80106705:	83 c4 10             	add    $0x10,%esp
  
}
80106708:	c9                   	leave  
80106709:	c3                   	ret    
8010670a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106715:	c9                   	leave  
80106716:	c3                   	ret    
80106717:	89 f6                	mov    %esi,%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106720 <sys_create_container>:

int 
sys_create_container(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
  return create_container();
  
}
80106723:	5d                   	pop    %ebp
  return create_container();
80106724:	e9 67 e3 ff ff       	jmp    80104a90 <create_container>
80106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106730 <sys_destroy_container>:

int 
sys_destroy_container(void)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 20             	sub    $0x20,%esp
  int a;
  if(argint(0, &a) < 0)
80106736:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106739:	50                   	push   %eax
8010673a:	6a 00                	push   $0x0
8010673c:	e8 1f ee ff ff       	call   80105560 <argint>
80106741:	83 c4 10             	add    $0x10,%esp
80106744:	85 c0                	test   %eax,%eax
80106746:	78 18                	js     80106760 <sys_destroy_container+0x30>
    return -1;
  return destroy_container(a);
80106748:	83 ec 0c             	sub    $0xc,%esp
8010674b:	ff 75 f4             	pushl  -0xc(%ebp)
8010674e:	e8 bd e4 ff ff       	call   80104c10 <destroy_container>
80106753:	83 c4 10             	add    $0x10,%esp
  
}
80106756:	c9                   	leave  
80106757:	c3                   	ret    
80106758:	90                   	nop
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106765:	c9                   	leave  
80106766:	c3                   	ret    
80106767:	89 f6                	mov    %esi,%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106770 <sys_join_container>:

int 
sys_join_container(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	83 ec 20             	sub    $0x20,%esp
  int a;
  if(argint(0, &a) < 0)
80106776:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106779:	50                   	push   %eax
8010677a:	6a 00                	push   $0x0
8010677c:	e8 df ed ff ff       	call   80105560 <argint>
80106781:	83 c4 10             	add    $0x10,%esp
80106784:	85 c0                	test   %eax,%eax
80106786:	78 18                	js     801067a0 <sys_join_container+0x30>
    return -1;
  return join_container(a);
80106788:	83 ec 0c             	sub    $0xc,%esp
8010678b:	ff 75 f4             	pushl  -0xc(%ebp)
8010678e:	e8 dd e4 ff ff       	call   80104c70 <join_container>
80106793:	83 c4 10             	add    $0x10,%esp
  
}
80106796:	c9                   	leave  
80106797:	c3                   	ret    
80106798:	90                   	nop
80106799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801067a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067a5:	c9                   	leave  
801067a6:	c3                   	ret    
801067a7:	89 f6                	mov    %esi,%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067b0 <sys_leave_container>:

int 
sys_leave_container(void)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
  return leave_container();
  
}
801067b3:	5d                   	pop    %ebp
  return leave_container();
801067b4:	e9 47 e6 ff ff       	jmp    80104e00 <leave_container>
801067b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067c0 <sys_container_malloc>:

int
sys_container_malloc(void)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 20             	sub    $0x20,%esp
  int a;
  if(argint(0, &a) < 0)
801067c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067c9:	50                   	push   %eax
801067ca:	6a 00                	push   $0x0
801067cc:	e8 8f ed ff ff       	call   80105560 <argint>
801067d1:	83 c4 10             	add    $0x10,%esp
801067d4:	85 c0                	test   %eax,%eax
801067d6:	78 20                	js     801067f8 <sys_container_malloc+0x38>
    return -1;
  cprintf("malloc\n");
801067d8:	83 ec 0c             	sub    $0xc,%esp
801067db:	68 a3 87 10 80       	push   $0x801087a3
801067e0:	e8 7b 9e ff ff       	call   80100660 <cprintf>
  return container_malloc(a);
801067e5:	58                   	pop    %eax
801067e6:	ff 75 f4             	pushl  -0xc(%ebp)
801067e9:	e8 d2 e6 ff ff       	call   80104ec0 <container_malloc>
801067ee:	83 c4 10             	add    $0x10,%esp
  
}
801067f1:	c9                   	leave  
801067f2:	c3                   	ret    
801067f3:	90                   	nop
801067f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801067f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067fd:	c9                   	leave  
801067fe:	c3                   	ret    

801067ff <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067ff:	1e                   	push   %ds
  pushl %es
80106800:	06                   	push   %es
  pushl %fs
80106801:	0f a0                	push   %fs
  pushl %gs
80106803:	0f a8                	push   %gs
  pushal
80106805:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106806:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010680a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010680c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010680e:	54                   	push   %esp
  call trap
8010680f:	e8 cc 00 00 00       	call   801068e0 <trap>
  addl $4, %esp
80106814:	83 c4 04             	add    $0x4,%esp

80106817 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106817:	61                   	popa   
  popl %gs
80106818:	0f a9                	pop    %gs
  popl %fs
8010681a:	0f a1                	pop    %fs
  popl %es
8010681c:	07                   	pop    %es
  popl %ds
8010681d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010681e:	83 c4 08             	add    $0x8,%esp
  iret
80106821:	cf                   	iret   
80106822:	66 90                	xchg   %ax,%ax
80106824:	66 90                	xchg   %ax,%ax
80106826:	66 90                	xchg   %ax,%ax
80106828:	66 90                	xchg   %ax,%ax
8010682a:	66 90                	xchg   %ax,%ax
8010682c:	66 90                	xchg   %ax,%ax
8010682e:	66 90                	xchg   %ax,%ax

80106830 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106830:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106831:	31 c0                	xor    %eax,%eax
{
80106833:	89 e5                	mov    %esp,%ebp
80106835:	83 ec 08             	sub    $0x8,%esp
80106838:	90                   	nop
80106839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106840:	8b 14 85 08 b4 10 80 	mov    -0x7fef4bf8(,%eax,4),%edx
80106847:	c7 04 c5 e2 31 13 80 	movl   $0x8e000008,-0x7fecce1e(,%eax,8)
8010684e:	08 00 00 8e 
80106852:	66 89 14 c5 e0 31 13 	mov    %dx,-0x7fecce20(,%eax,8)
80106859:	80 
8010685a:	c1 ea 10             	shr    $0x10,%edx
8010685d:	66 89 14 c5 e6 31 13 	mov    %dx,-0x7fecce1a(,%eax,8)
80106864:	80 
  for(i = 0; i < 256; i++)
80106865:	83 c0 01             	add    $0x1,%eax
80106868:	3d 00 01 00 00       	cmp    $0x100,%eax
8010686d:	75 d1                	jne    80106840 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010686f:	a1 08 b5 10 80       	mov    0x8010b508,%eax

  initlock(&tickslock, "time");
80106874:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106877:	c7 05 e2 33 13 80 08 	movl   $0xef000008,0x801333e2
8010687e:	00 00 ef 
  initlock(&tickslock, "time");
80106881:	68 cf 89 10 80       	push   $0x801089cf
80106886:	68 a0 31 13 80       	push   $0x801331a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010688b:	66 a3 e0 33 13 80    	mov    %ax,0x801333e0
80106891:	c1 e8 10             	shr    $0x10,%eax
80106894:	66 a3 e6 33 13 80    	mov    %ax,0x801333e6
  initlock(&tickslock, "time");
8010689a:	e8 71 e7 ff ff       	call   80105010 <initlock>
}
8010689f:	83 c4 10             	add    $0x10,%esp
801068a2:	c9                   	leave  
801068a3:	c3                   	ret    
801068a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801068aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801068b0 <idtinit>:

void
idtinit(void)
{
801068b0:	55                   	push   %ebp
  pd[0] = size-1;
801068b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801068b6:	89 e5                	mov    %esp,%ebp
801068b8:	83 ec 10             	sub    $0x10,%esp
801068bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801068bf:	b8 e0 31 13 80       	mov    $0x801331e0,%eax
801068c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801068c8:	c1 e8 10             	shr    $0x10,%eax
801068cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801068cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801068d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801068d5:	c9                   	leave  
801068d6:	c3                   	ret    
801068d7:	89 f6                	mov    %esi,%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
801068e6:	83 ec 1c             	sub    $0x1c,%esp
801068e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801068ec:	8b 47 30             	mov    0x30(%edi),%eax
801068ef:	83 f8 40             	cmp    $0x40,%eax
801068f2:	0f 84 f0 00 00 00    	je     801069e8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801068f8:	83 e8 20             	sub    $0x20,%eax
801068fb:	83 f8 1f             	cmp    $0x1f,%eax
801068fe:	77 10                	ja     80106910 <trap+0x30>
80106900:	ff 24 85 78 8a 10 80 	jmp    *-0x7fef7588(,%eax,4)
80106907:	89 f6                	mov    %esi,%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106910:	e8 2b d0 ff ff       	call   80103940 <myproc>
80106915:	85 c0                	test   %eax,%eax
80106917:	8b 5f 38             	mov    0x38(%edi),%ebx
8010691a:	0f 84 14 02 00 00    	je     80106b34 <trap+0x254>
80106920:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106924:	0f 84 0a 02 00 00    	je     80106b34 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010692a:	0f 20 d1             	mov    %cr2,%ecx
8010692d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106930:	e8 eb cf ff ff       	call   80103920 <cpuid>
80106935:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106938:	8b 47 34             	mov    0x34(%edi),%eax
8010693b:	8b 77 30             	mov    0x30(%edi),%esi
8010693e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106941:	e8 fa cf ff ff       	call   80103940 <myproc>
80106946:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106949:	e8 f2 cf ff ff       	call   80103940 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010694e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106951:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106954:	51                   	push   %ecx
80106955:	53                   	push   %ebx
80106956:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106957:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010695a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010695d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010695e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106961:	52                   	push   %edx
80106962:	ff 70 10             	pushl  0x10(%eax)
80106965:	68 34 8a 10 80       	push   $0x80108a34
8010696a:	e8 f1 9c ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010696f:	83 c4 20             	add    $0x20,%esp
80106972:	e8 c9 cf ff ff       	call   80103940 <myproc>
80106977:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010697e:	e8 bd cf ff ff       	call   80103940 <myproc>
80106983:	85 c0                	test   %eax,%eax
80106985:	74 1d                	je     801069a4 <trap+0xc4>
80106987:	e8 b4 cf ff ff       	call   80103940 <myproc>
8010698c:	8b 50 24             	mov    0x24(%eax),%edx
8010698f:	85 d2                	test   %edx,%edx
80106991:	74 11                	je     801069a4 <trap+0xc4>
80106993:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106997:	83 e0 03             	and    $0x3,%eax
8010699a:	66 83 f8 03          	cmp    $0x3,%ax
8010699e:	0f 84 4c 01 00 00    	je     80106af0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801069a4:	e8 97 cf ff ff       	call   80103940 <myproc>
801069a9:	85 c0                	test   %eax,%eax
801069ab:	74 0b                	je     801069b8 <trap+0xd8>
801069ad:	e8 8e cf ff ff       	call   80103940 <myproc>
801069b2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801069b6:	74 68                	je     80106a20 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069b8:	e8 83 cf ff ff       	call   80103940 <myproc>
801069bd:	85 c0                	test   %eax,%eax
801069bf:	74 19                	je     801069da <trap+0xfa>
801069c1:	e8 7a cf ff ff       	call   80103940 <myproc>
801069c6:	8b 40 24             	mov    0x24(%eax),%eax
801069c9:	85 c0                	test   %eax,%eax
801069cb:	74 0d                	je     801069da <trap+0xfa>
801069cd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801069d1:	83 e0 03             	and    $0x3,%eax
801069d4:	66 83 f8 03          	cmp    $0x3,%ax
801069d8:	74 37                	je     80106a11 <trap+0x131>
    exit();
}
801069da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069dd:	5b                   	pop    %ebx
801069de:	5e                   	pop    %esi
801069df:	5f                   	pop    %edi
801069e0:	5d                   	pop    %ebp
801069e1:	c3                   	ret    
801069e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801069e8:	e8 53 cf ff ff       	call   80103940 <myproc>
801069ed:	8b 58 24             	mov    0x24(%eax),%ebx
801069f0:	85 db                	test   %ebx,%ebx
801069f2:	0f 85 e8 00 00 00    	jne    80106ae0 <trap+0x200>
    myproc()->tf = tf;
801069f8:	e8 43 cf ff ff       	call   80103940 <myproc>
801069fd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106a00:	e8 4b ec ff ff       	call   80105650 <syscall>
    if(myproc()->killed)
80106a05:	e8 36 cf ff ff       	call   80103940 <myproc>
80106a0a:	8b 48 24             	mov    0x24(%eax),%ecx
80106a0d:	85 c9                	test   %ecx,%ecx
80106a0f:	74 c9                	je     801069da <trap+0xfa>
}
80106a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a14:	5b                   	pop    %ebx
80106a15:	5e                   	pop    %esi
80106a16:	5f                   	pop    %edi
80106a17:	5d                   	pop    %ebp
      exit();
80106a18:	e9 43 d3 ff ff       	jmp    80103d60 <exit>
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106a20:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106a24:	75 92                	jne    801069b8 <trap+0xd8>
    yield();
80106a26:	e8 65 d4 ff ff       	call   80103e90 <yield>
80106a2b:	eb 8b                	jmp    801069b8 <trap+0xd8>
80106a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106a30:	e8 eb ce ff ff       	call   80103920 <cpuid>
80106a35:	85 c0                	test   %eax,%eax
80106a37:	0f 84 c3 00 00 00    	je     80106b00 <trap+0x220>
    lapiceoi();
80106a3d:	e8 1e bd ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a42:	e8 f9 ce ff ff       	call   80103940 <myproc>
80106a47:	85 c0                	test   %eax,%eax
80106a49:	0f 85 38 ff ff ff    	jne    80106987 <trap+0xa7>
80106a4f:	e9 50 ff ff ff       	jmp    801069a4 <trap+0xc4>
80106a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106a58:	e8 c3 bb ff ff       	call   80102620 <kbdintr>
    lapiceoi();
80106a5d:	e8 fe bc ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a62:	e8 d9 ce ff ff       	call   80103940 <myproc>
80106a67:	85 c0                	test   %eax,%eax
80106a69:	0f 85 18 ff ff ff    	jne    80106987 <trap+0xa7>
80106a6f:	e9 30 ff ff ff       	jmp    801069a4 <trap+0xc4>
80106a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106a78:	e8 53 02 00 00       	call   80106cd0 <uartintr>
    lapiceoi();
80106a7d:	e8 de bc ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a82:	e8 b9 ce ff ff       	call   80103940 <myproc>
80106a87:	85 c0                	test   %eax,%eax
80106a89:	0f 85 f8 fe ff ff    	jne    80106987 <trap+0xa7>
80106a8f:	e9 10 ff ff ff       	jmp    801069a4 <trap+0xc4>
80106a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a98:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106a9c:	8b 77 38             	mov    0x38(%edi),%esi
80106a9f:	e8 7c ce ff ff       	call   80103920 <cpuid>
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	50                   	push   %eax
80106aa7:	68 dc 89 10 80       	push   $0x801089dc
80106aac:	e8 af 9b ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106ab1:	e8 aa bc ff ff       	call   80102760 <lapiceoi>
    break;
80106ab6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ab9:	e8 82 ce ff ff       	call   80103940 <myproc>
80106abe:	85 c0                	test   %eax,%eax
80106ac0:	0f 85 c1 fe ff ff    	jne    80106987 <trap+0xa7>
80106ac6:	e9 d9 fe ff ff       	jmp    801069a4 <trap+0xc4>
80106acb:	90                   	nop
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106ad0:	e8 bb b5 ff ff       	call   80102090 <ideintr>
80106ad5:	e9 63 ff ff ff       	jmp    80106a3d <trap+0x15d>
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106ae0:	e8 7b d2 ff ff       	call   80103d60 <exit>
80106ae5:	e9 0e ff ff ff       	jmp    801069f8 <trap+0x118>
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106af0:	e8 6b d2 ff ff       	call   80103d60 <exit>
80106af5:	e9 aa fe ff ff       	jmp    801069a4 <trap+0xc4>
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106b00:	83 ec 0c             	sub    $0xc,%esp
80106b03:	68 a0 31 13 80       	push   $0x801331a0
80106b08:	e8 43 e6 ff ff       	call   80105150 <acquire>
      wakeup(&ticks);
80106b0d:	c7 04 24 e0 39 13 80 	movl   $0x801339e0,(%esp)
      ticks++;
80106b14:	83 05 e0 39 13 80 01 	addl   $0x1,0x801339e0
      wakeup(&ticks);
80106b1b:	e8 80 d5 ff ff       	call   801040a0 <wakeup>
      release(&tickslock);
80106b20:	c7 04 24 a0 31 13 80 	movl   $0x801331a0,(%esp)
80106b27:	e8 e4 e6 ff ff       	call   80105210 <release>
80106b2c:	83 c4 10             	add    $0x10,%esp
80106b2f:	e9 09 ff ff ff       	jmp    80106a3d <trap+0x15d>
80106b34:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b37:	e8 e4 cd ff ff       	call   80103920 <cpuid>
80106b3c:	83 ec 0c             	sub    $0xc,%esp
80106b3f:	56                   	push   %esi
80106b40:	53                   	push   %ebx
80106b41:	50                   	push   %eax
80106b42:	ff 77 30             	pushl  0x30(%edi)
80106b45:	68 00 8a 10 80       	push   $0x80108a00
80106b4a:	e8 11 9b ff ff       	call   80100660 <cprintf>
      panic("trap");
80106b4f:	83 c4 14             	add    $0x14,%esp
80106b52:	68 d4 89 10 80       	push   $0x801089d4
80106b57:	e8 34 98 ff ff       	call   80100390 <panic>
80106b5c:	66 90                	xchg   %ax,%ax
80106b5e:	66 90                	xchg   %ax,%ax

80106b60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106b60:	a1 6c ba 10 80       	mov    0x8010ba6c,%eax
{
80106b65:	55                   	push   %ebp
80106b66:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b68:	85 c0                	test   %eax,%eax
80106b6a:	74 1c                	je     80106b88 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b6c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b71:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b72:	a8 01                	test   $0x1,%al
80106b74:	74 12                	je     80106b88 <uartgetc+0x28>
80106b76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b7b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b7c:	0f b6 c0             	movzbl %al,%eax
}
80106b7f:	5d                   	pop    %ebp
80106b80:	c3                   	ret    
80106b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b8d:	5d                   	pop    %ebp
80106b8e:	c3                   	ret    
80106b8f:	90                   	nop

80106b90 <uartputc.part.0>:
uartputc(int c)
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	89 c7                	mov    %eax,%edi
80106b98:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106ba2:	83 ec 0c             	sub    $0xc,%esp
80106ba5:	eb 1b                	jmp    80106bc2 <uartputc.part.0+0x32>
80106ba7:	89 f6                	mov    %esi,%esi
80106ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106bb0:	83 ec 0c             	sub    $0xc,%esp
80106bb3:	6a 0a                	push   $0xa
80106bb5:	e8 c6 bb ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bba:	83 c4 10             	add    $0x10,%esp
80106bbd:	83 eb 01             	sub    $0x1,%ebx
80106bc0:	74 07                	je     80106bc9 <uartputc.part.0+0x39>
80106bc2:	89 f2                	mov    %esi,%edx
80106bc4:	ec                   	in     (%dx),%al
80106bc5:	a8 20                	test   $0x20,%al
80106bc7:	74 e7                	je     80106bb0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106bc9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bce:	89 f8                	mov    %edi,%eax
80106bd0:	ee                   	out    %al,(%dx)
}
80106bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bd4:	5b                   	pop    %ebx
80106bd5:	5e                   	pop    %esi
80106bd6:	5f                   	pop    %edi
80106bd7:	5d                   	pop    %ebp
80106bd8:	c3                   	ret    
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106be0 <uartinit>:
{
80106be0:	55                   	push   %ebp
80106be1:	31 c9                	xor    %ecx,%ecx
80106be3:	89 c8                	mov    %ecx,%eax
80106be5:	89 e5                	mov    %esp,%ebp
80106be7:	57                   	push   %edi
80106be8:	56                   	push   %esi
80106be9:	53                   	push   %ebx
80106bea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106bef:	89 da                	mov    %ebx,%edx
80106bf1:	83 ec 0c             	sub    $0xc,%esp
80106bf4:	ee                   	out    %al,(%dx)
80106bf5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106bfa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106bff:	89 fa                	mov    %edi,%edx
80106c01:	ee                   	out    %al,(%dx)
80106c02:	b8 0c 00 00 00       	mov    $0xc,%eax
80106c07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c0c:	ee                   	out    %al,(%dx)
80106c0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106c12:	89 c8                	mov    %ecx,%eax
80106c14:	89 f2                	mov    %esi,%edx
80106c16:	ee                   	out    %al,(%dx)
80106c17:	b8 03 00 00 00       	mov    $0x3,%eax
80106c1c:	89 fa                	mov    %edi,%edx
80106c1e:	ee                   	out    %al,(%dx)
80106c1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106c24:	89 c8                	mov    %ecx,%eax
80106c26:	ee                   	out    %al,(%dx)
80106c27:	b8 01 00 00 00       	mov    $0x1,%eax
80106c2c:	89 f2                	mov    %esi,%edx
80106c2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106c35:	3c ff                	cmp    $0xff,%al
80106c37:	74 5a                	je     80106c93 <uartinit+0xb3>
  uart = 1;
80106c39:	c7 05 6c ba 10 80 01 	movl   $0x1,0x8010ba6c
80106c40:	00 00 00 
80106c43:	89 da                	mov    %ebx,%edx
80106c45:	ec                   	in     (%dx),%al
80106c46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c4b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106c4c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106c4f:	bb f8 8a 10 80       	mov    $0x80108af8,%ebx
  ioapicenable(IRQ_COM1, 0);
80106c54:	6a 00                	push   $0x0
80106c56:	6a 04                	push   $0x4
80106c58:	e8 83 b6 ff ff       	call   801022e0 <ioapicenable>
80106c5d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c60:	b8 78 00 00 00       	mov    $0x78,%eax
80106c65:	eb 13                	jmp    80106c7a <uartinit+0x9a>
80106c67:	89 f6                	mov    %esi,%esi
80106c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c70:	83 c3 01             	add    $0x1,%ebx
80106c73:	0f be 03             	movsbl (%ebx),%eax
80106c76:	84 c0                	test   %al,%al
80106c78:	74 19                	je     80106c93 <uartinit+0xb3>
  if(!uart)
80106c7a:	8b 15 6c ba 10 80    	mov    0x8010ba6c,%edx
80106c80:	85 d2                	test   %edx,%edx
80106c82:	74 ec                	je     80106c70 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106c84:	83 c3 01             	add    $0x1,%ebx
80106c87:	e8 04 ff ff ff       	call   80106b90 <uartputc.part.0>
80106c8c:	0f be 03             	movsbl (%ebx),%eax
80106c8f:	84 c0                	test   %al,%al
80106c91:	75 e7                	jne    80106c7a <uartinit+0x9a>
}
80106c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c96:	5b                   	pop    %ebx
80106c97:	5e                   	pop    %esi
80106c98:	5f                   	pop    %edi
80106c99:	5d                   	pop    %ebp
80106c9a:	c3                   	ret    
80106c9b:	90                   	nop
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <uartputc>:
  if(!uart)
80106ca0:	8b 15 6c ba 10 80    	mov    0x8010ba6c,%edx
{
80106ca6:	55                   	push   %ebp
80106ca7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106ca9:	85 d2                	test   %edx,%edx
{
80106cab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106cae:	74 10                	je     80106cc0 <uartputc+0x20>
}
80106cb0:	5d                   	pop    %ebp
80106cb1:	e9 da fe ff ff       	jmp    80106b90 <uartputc.part.0>
80106cb6:	8d 76 00             	lea    0x0(%esi),%esi
80106cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106cc0:	5d                   	pop    %ebp
80106cc1:	c3                   	ret    
80106cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <uartintr>:

void
uartintr(void)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106cd6:	68 60 6b 10 80       	push   $0x80106b60
80106cdb:	e8 30 9b ff ff       	call   80100810 <consoleintr>
}
80106ce0:	83 c4 10             	add    $0x10,%esp
80106ce3:	c9                   	leave  
80106ce4:	c3                   	ret    

80106ce5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $0
80106ce7:	6a 00                	push   $0x0
  jmp alltraps
80106ce9:	e9 11 fb ff ff       	jmp    801067ff <alltraps>

80106cee <vector1>:
.globl vector1
vector1:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $1
80106cf0:	6a 01                	push   $0x1
  jmp alltraps
80106cf2:	e9 08 fb ff ff       	jmp    801067ff <alltraps>

80106cf7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $2
80106cf9:	6a 02                	push   $0x2
  jmp alltraps
80106cfb:	e9 ff fa ff ff       	jmp    801067ff <alltraps>

80106d00 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $3
80106d02:	6a 03                	push   $0x3
  jmp alltraps
80106d04:	e9 f6 fa ff ff       	jmp    801067ff <alltraps>

80106d09 <vector4>:
.globl vector4
vector4:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $4
80106d0b:	6a 04                	push   $0x4
  jmp alltraps
80106d0d:	e9 ed fa ff ff       	jmp    801067ff <alltraps>

80106d12 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $5
80106d14:	6a 05                	push   $0x5
  jmp alltraps
80106d16:	e9 e4 fa ff ff       	jmp    801067ff <alltraps>

80106d1b <vector6>:
.globl vector6
vector6:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $6
80106d1d:	6a 06                	push   $0x6
  jmp alltraps
80106d1f:	e9 db fa ff ff       	jmp    801067ff <alltraps>

80106d24 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $7
80106d26:	6a 07                	push   $0x7
  jmp alltraps
80106d28:	e9 d2 fa ff ff       	jmp    801067ff <alltraps>

80106d2d <vector8>:
.globl vector8
vector8:
  pushl $8
80106d2d:	6a 08                	push   $0x8
  jmp alltraps
80106d2f:	e9 cb fa ff ff       	jmp    801067ff <alltraps>

80106d34 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $9
80106d36:	6a 09                	push   $0x9
  jmp alltraps
80106d38:	e9 c2 fa ff ff       	jmp    801067ff <alltraps>

80106d3d <vector10>:
.globl vector10
vector10:
  pushl $10
80106d3d:	6a 0a                	push   $0xa
  jmp alltraps
80106d3f:	e9 bb fa ff ff       	jmp    801067ff <alltraps>

80106d44 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d44:	6a 0b                	push   $0xb
  jmp alltraps
80106d46:	e9 b4 fa ff ff       	jmp    801067ff <alltraps>

80106d4b <vector12>:
.globl vector12
vector12:
  pushl $12
80106d4b:	6a 0c                	push   $0xc
  jmp alltraps
80106d4d:	e9 ad fa ff ff       	jmp    801067ff <alltraps>

80106d52 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d52:	6a 0d                	push   $0xd
  jmp alltraps
80106d54:	e9 a6 fa ff ff       	jmp    801067ff <alltraps>

80106d59 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d59:	6a 0e                	push   $0xe
  jmp alltraps
80106d5b:	e9 9f fa ff ff       	jmp    801067ff <alltraps>

80106d60 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $15
80106d62:	6a 0f                	push   $0xf
  jmp alltraps
80106d64:	e9 96 fa ff ff       	jmp    801067ff <alltraps>

80106d69 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $16
80106d6b:	6a 10                	push   $0x10
  jmp alltraps
80106d6d:	e9 8d fa ff ff       	jmp    801067ff <alltraps>

80106d72 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d72:	6a 11                	push   $0x11
  jmp alltraps
80106d74:	e9 86 fa ff ff       	jmp    801067ff <alltraps>

80106d79 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $18
80106d7b:	6a 12                	push   $0x12
  jmp alltraps
80106d7d:	e9 7d fa ff ff       	jmp    801067ff <alltraps>

80106d82 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $19
80106d84:	6a 13                	push   $0x13
  jmp alltraps
80106d86:	e9 74 fa ff ff       	jmp    801067ff <alltraps>

80106d8b <vector20>:
.globl vector20
vector20:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $20
80106d8d:	6a 14                	push   $0x14
  jmp alltraps
80106d8f:	e9 6b fa ff ff       	jmp    801067ff <alltraps>

80106d94 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $21
80106d96:	6a 15                	push   $0x15
  jmp alltraps
80106d98:	e9 62 fa ff ff       	jmp    801067ff <alltraps>

80106d9d <vector22>:
.globl vector22
vector22:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $22
80106d9f:	6a 16                	push   $0x16
  jmp alltraps
80106da1:	e9 59 fa ff ff       	jmp    801067ff <alltraps>

80106da6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $23
80106da8:	6a 17                	push   $0x17
  jmp alltraps
80106daa:	e9 50 fa ff ff       	jmp    801067ff <alltraps>

80106daf <vector24>:
.globl vector24
vector24:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $24
80106db1:	6a 18                	push   $0x18
  jmp alltraps
80106db3:	e9 47 fa ff ff       	jmp    801067ff <alltraps>

80106db8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $25
80106dba:	6a 19                	push   $0x19
  jmp alltraps
80106dbc:	e9 3e fa ff ff       	jmp    801067ff <alltraps>

80106dc1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $26
80106dc3:	6a 1a                	push   $0x1a
  jmp alltraps
80106dc5:	e9 35 fa ff ff       	jmp    801067ff <alltraps>

80106dca <vector27>:
.globl vector27
vector27:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $27
80106dcc:	6a 1b                	push   $0x1b
  jmp alltraps
80106dce:	e9 2c fa ff ff       	jmp    801067ff <alltraps>

80106dd3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $28
80106dd5:	6a 1c                	push   $0x1c
  jmp alltraps
80106dd7:	e9 23 fa ff ff       	jmp    801067ff <alltraps>

80106ddc <vector29>:
.globl vector29
vector29:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $29
80106dde:	6a 1d                	push   $0x1d
  jmp alltraps
80106de0:	e9 1a fa ff ff       	jmp    801067ff <alltraps>

80106de5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $30
80106de7:	6a 1e                	push   $0x1e
  jmp alltraps
80106de9:	e9 11 fa ff ff       	jmp    801067ff <alltraps>

80106dee <vector31>:
.globl vector31
vector31:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $31
80106df0:	6a 1f                	push   $0x1f
  jmp alltraps
80106df2:	e9 08 fa ff ff       	jmp    801067ff <alltraps>

80106df7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $32
80106df9:	6a 20                	push   $0x20
  jmp alltraps
80106dfb:	e9 ff f9 ff ff       	jmp    801067ff <alltraps>

80106e00 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $33
80106e02:	6a 21                	push   $0x21
  jmp alltraps
80106e04:	e9 f6 f9 ff ff       	jmp    801067ff <alltraps>

80106e09 <vector34>:
.globl vector34
vector34:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $34
80106e0b:	6a 22                	push   $0x22
  jmp alltraps
80106e0d:	e9 ed f9 ff ff       	jmp    801067ff <alltraps>

80106e12 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $35
80106e14:	6a 23                	push   $0x23
  jmp alltraps
80106e16:	e9 e4 f9 ff ff       	jmp    801067ff <alltraps>

80106e1b <vector36>:
.globl vector36
vector36:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $36
80106e1d:	6a 24                	push   $0x24
  jmp alltraps
80106e1f:	e9 db f9 ff ff       	jmp    801067ff <alltraps>

80106e24 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $37
80106e26:	6a 25                	push   $0x25
  jmp alltraps
80106e28:	e9 d2 f9 ff ff       	jmp    801067ff <alltraps>

80106e2d <vector38>:
.globl vector38
vector38:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $38
80106e2f:	6a 26                	push   $0x26
  jmp alltraps
80106e31:	e9 c9 f9 ff ff       	jmp    801067ff <alltraps>

80106e36 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $39
80106e38:	6a 27                	push   $0x27
  jmp alltraps
80106e3a:	e9 c0 f9 ff ff       	jmp    801067ff <alltraps>

80106e3f <vector40>:
.globl vector40
vector40:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $40
80106e41:	6a 28                	push   $0x28
  jmp alltraps
80106e43:	e9 b7 f9 ff ff       	jmp    801067ff <alltraps>

80106e48 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $41
80106e4a:	6a 29                	push   $0x29
  jmp alltraps
80106e4c:	e9 ae f9 ff ff       	jmp    801067ff <alltraps>

80106e51 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $42
80106e53:	6a 2a                	push   $0x2a
  jmp alltraps
80106e55:	e9 a5 f9 ff ff       	jmp    801067ff <alltraps>

80106e5a <vector43>:
.globl vector43
vector43:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $43
80106e5c:	6a 2b                	push   $0x2b
  jmp alltraps
80106e5e:	e9 9c f9 ff ff       	jmp    801067ff <alltraps>

80106e63 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $44
80106e65:	6a 2c                	push   $0x2c
  jmp alltraps
80106e67:	e9 93 f9 ff ff       	jmp    801067ff <alltraps>

80106e6c <vector45>:
.globl vector45
vector45:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $45
80106e6e:	6a 2d                	push   $0x2d
  jmp alltraps
80106e70:	e9 8a f9 ff ff       	jmp    801067ff <alltraps>

80106e75 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $46
80106e77:	6a 2e                	push   $0x2e
  jmp alltraps
80106e79:	e9 81 f9 ff ff       	jmp    801067ff <alltraps>

80106e7e <vector47>:
.globl vector47
vector47:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $47
80106e80:	6a 2f                	push   $0x2f
  jmp alltraps
80106e82:	e9 78 f9 ff ff       	jmp    801067ff <alltraps>

80106e87 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $48
80106e89:	6a 30                	push   $0x30
  jmp alltraps
80106e8b:	e9 6f f9 ff ff       	jmp    801067ff <alltraps>

80106e90 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $49
80106e92:	6a 31                	push   $0x31
  jmp alltraps
80106e94:	e9 66 f9 ff ff       	jmp    801067ff <alltraps>

80106e99 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $50
80106e9b:	6a 32                	push   $0x32
  jmp alltraps
80106e9d:	e9 5d f9 ff ff       	jmp    801067ff <alltraps>

80106ea2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $51
80106ea4:	6a 33                	push   $0x33
  jmp alltraps
80106ea6:	e9 54 f9 ff ff       	jmp    801067ff <alltraps>

80106eab <vector52>:
.globl vector52
vector52:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $52
80106ead:	6a 34                	push   $0x34
  jmp alltraps
80106eaf:	e9 4b f9 ff ff       	jmp    801067ff <alltraps>

80106eb4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $53
80106eb6:	6a 35                	push   $0x35
  jmp alltraps
80106eb8:	e9 42 f9 ff ff       	jmp    801067ff <alltraps>

80106ebd <vector54>:
.globl vector54
vector54:
  pushl $0
80106ebd:	6a 00                	push   $0x0
  pushl $54
80106ebf:	6a 36                	push   $0x36
  jmp alltraps
80106ec1:	e9 39 f9 ff ff       	jmp    801067ff <alltraps>

80106ec6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ec6:	6a 00                	push   $0x0
  pushl $55
80106ec8:	6a 37                	push   $0x37
  jmp alltraps
80106eca:	e9 30 f9 ff ff       	jmp    801067ff <alltraps>

80106ecf <vector56>:
.globl vector56
vector56:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $56
80106ed1:	6a 38                	push   $0x38
  jmp alltraps
80106ed3:	e9 27 f9 ff ff       	jmp    801067ff <alltraps>

80106ed8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $57
80106eda:	6a 39                	push   $0x39
  jmp alltraps
80106edc:	e9 1e f9 ff ff       	jmp    801067ff <alltraps>

80106ee1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ee1:	6a 00                	push   $0x0
  pushl $58
80106ee3:	6a 3a                	push   $0x3a
  jmp alltraps
80106ee5:	e9 15 f9 ff ff       	jmp    801067ff <alltraps>

80106eea <vector59>:
.globl vector59
vector59:
  pushl $0
80106eea:	6a 00                	push   $0x0
  pushl $59
80106eec:	6a 3b                	push   $0x3b
  jmp alltraps
80106eee:	e9 0c f9 ff ff       	jmp    801067ff <alltraps>

80106ef3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $60
80106ef5:	6a 3c                	push   $0x3c
  jmp alltraps
80106ef7:	e9 03 f9 ff ff       	jmp    801067ff <alltraps>

80106efc <vector61>:
.globl vector61
vector61:
  pushl $0
80106efc:	6a 00                	push   $0x0
  pushl $61
80106efe:	6a 3d                	push   $0x3d
  jmp alltraps
80106f00:	e9 fa f8 ff ff       	jmp    801067ff <alltraps>

80106f05 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $62
80106f07:	6a 3e                	push   $0x3e
  jmp alltraps
80106f09:	e9 f1 f8 ff ff       	jmp    801067ff <alltraps>

80106f0e <vector63>:
.globl vector63
vector63:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $63
80106f10:	6a 3f                	push   $0x3f
  jmp alltraps
80106f12:	e9 e8 f8 ff ff       	jmp    801067ff <alltraps>

80106f17 <vector64>:
.globl vector64
vector64:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $64
80106f19:	6a 40                	push   $0x40
  jmp alltraps
80106f1b:	e9 df f8 ff ff       	jmp    801067ff <alltraps>

80106f20 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $65
80106f22:	6a 41                	push   $0x41
  jmp alltraps
80106f24:	e9 d6 f8 ff ff       	jmp    801067ff <alltraps>

80106f29 <vector66>:
.globl vector66
vector66:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $66
80106f2b:	6a 42                	push   $0x42
  jmp alltraps
80106f2d:	e9 cd f8 ff ff       	jmp    801067ff <alltraps>

80106f32 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $67
80106f34:	6a 43                	push   $0x43
  jmp alltraps
80106f36:	e9 c4 f8 ff ff       	jmp    801067ff <alltraps>

80106f3b <vector68>:
.globl vector68
vector68:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $68
80106f3d:	6a 44                	push   $0x44
  jmp alltraps
80106f3f:	e9 bb f8 ff ff       	jmp    801067ff <alltraps>

80106f44 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $69
80106f46:	6a 45                	push   $0x45
  jmp alltraps
80106f48:	e9 b2 f8 ff ff       	jmp    801067ff <alltraps>

80106f4d <vector70>:
.globl vector70
vector70:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $70
80106f4f:	6a 46                	push   $0x46
  jmp alltraps
80106f51:	e9 a9 f8 ff ff       	jmp    801067ff <alltraps>

80106f56 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $71
80106f58:	6a 47                	push   $0x47
  jmp alltraps
80106f5a:	e9 a0 f8 ff ff       	jmp    801067ff <alltraps>

80106f5f <vector72>:
.globl vector72
vector72:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $72
80106f61:	6a 48                	push   $0x48
  jmp alltraps
80106f63:	e9 97 f8 ff ff       	jmp    801067ff <alltraps>

80106f68 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f68:	6a 00                	push   $0x0
  pushl $73
80106f6a:	6a 49                	push   $0x49
  jmp alltraps
80106f6c:	e9 8e f8 ff ff       	jmp    801067ff <alltraps>

80106f71 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f71:	6a 00                	push   $0x0
  pushl $74
80106f73:	6a 4a                	push   $0x4a
  jmp alltraps
80106f75:	e9 85 f8 ff ff       	jmp    801067ff <alltraps>

80106f7a <vector75>:
.globl vector75
vector75:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $75
80106f7c:	6a 4b                	push   $0x4b
  jmp alltraps
80106f7e:	e9 7c f8 ff ff       	jmp    801067ff <alltraps>

80106f83 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $76
80106f85:	6a 4c                	push   $0x4c
  jmp alltraps
80106f87:	e9 73 f8 ff ff       	jmp    801067ff <alltraps>

80106f8c <vector77>:
.globl vector77
vector77:
  pushl $0
80106f8c:	6a 00                	push   $0x0
  pushl $77
80106f8e:	6a 4d                	push   $0x4d
  jmp alltraps
80106f90:	e9 6a f8 ff ff       	jmp    801067ff <alltraps>

80106f95 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f95:	6a 00                	push   $0x0
  pushl $78
80106f97:	6a 4e                	push   $0x4e
  jmp alltraps
80106f99:	e9 61 f8 ff ff       	jmp    801067ff <alltraps>

80106f9e <vector79>:
.globl vector79
vector79:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $79
80106fa0:	6a 4f                	push   $0x4f
  jmp alltraps
80106fa2:	e9 58 f8 ff ff       	jmp    801067ff <alltraps>

80106fa7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $80
80106fa9:	6a 50                	push   $0x50
  jmp alltraps
80106fab:	e9 4f f8 ff ff       	jmp    801067ff <alltraps>

80106fb0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106fb0:	6a 00                	push   $0x0
  pushl $81
80106fb2:	6a 51                	push   $0x51
  jmp alltraps
80106fb4:	e9 46 f8 ff ff       	jmp    801067ff <alltraps>

80106fb9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106fb9:	6a 00                	push   $0x0
  pushl $82
80106fbb:	6a 52                	push   $0x52
  jmp alltraps
80106fbd:	e9 3d f8 ff ff       	jmp    801067ff <alltraps>

80106fc2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106fc2:	6a 00                	push   $0x0
  pushl $83
80106fc4:	6a 53                	push   $0x53
  jmp alltraps
80106fc6:	e9 34 f8 ff ff       	jmp    801067ff <alltraps>

80106fcb <vector84>:
.globl vector84
vector84:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $84
80106fcd:	6a 54                	push   $0x54
  jmp alltraps
80106fcf:	e9 2b f8 ff ff       	jmp    801067ff <alltraps>

80106fd4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $85
80106fd6:	6a 55                	push   $0x55
  jmp alltraps
80106fd8:	e9 22 f8 ff ff       	jmp    801067ff <alltraps>

80106fdd <vector86>:
.globl vector86
vector86:
  pushl $0
80106fdd:	6a 00                	push   $0x0
  pushl $86
80106fdf:	6a 56                	push   $0x56
  jmp alltraps
80106fe1:	e9 19 f8 ff ff       	jmp    801067ff <alltraps>

80106fe6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $87
80106fe8:	6a 57                	push   $0x57
  jmp alltraps
80106fea:	e9 10 f8 ff ff       	jmp    801067ff <alltraps>

80106fef <vector88>:
.globl vector88
vector88:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $88
80106ff1:	6a 58                	push   $0x58
  jmp alltraps
80106ff3:	e9 07 f8 ff ff       	jmp    801067ff <alltraps>

80106ff8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $89
80106ffa:	6a 59                	push   $0x59
  jmp alltraps
80106ffc:	e9 fe f7 ff ff       	jmp    801067ff <alltraps>

80107001 <vector90>:
.globl vector90
vector90:
  pushl $0
80107001:	6a 00                	push   $0x0
  pushl $90
80107003:	6a 5a                	push   $0x5a
  jmp alltraps
80107005:	e9 f5 f7 ff ff       	jmp    801067ff <alltraps>

8010700a <vector91>:
.globl vector91
vector91:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $91
8010700c:	6a 5b                	push   $0x5b
  jmp alltraps
8010700e:	e9 ec f7 ff ff       	jmp    801067ff <alltraps>

80107013 <vector92>:
.globl vector92
vector92:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $92
80107015:	6a 5c                	push   $0x5c
  jmp alltraps
80107017:	e9 e3 f7 ff ff       	jmp    801067ff <alltraps>

8010701c <vector93>:
.globl vector93
vector93:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $93
8010701e:	6a 5d                	push   $0x5d
  jmp alltraps
80107020:	e9 da f7 ff ff       	jmp    801067ff <alltraps>

80107025 <vector94>:
.globl vector94
vector94:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $94
80107027:	6a 5e                	push   $0x5e
  jmp alltraps
80107029:	e9 d1 f7 ff ff       	jmp    801067ff <alltraps>

8010702e <vector95>:
.globl vector95
vector95:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $95
80107030:	6a 5f                	push   $0x5f
  jmp alltraps
80107032:	e9 c8 f7 ff ff       	jmp    801067ff <alltraps>

80107037 <vector96>:
.globl vector96
vector96:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $96
80107039:	6a 60                	push   $0x60
  jmp alltraps
8010703b:	e9 bf f7 ff ff       	jmp    801067ff <alltraps>

80107040 <vector97>:
.globl vector97
vector97:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $97
80107042:	6a 61                	push   $0x61
  jmp alltraps
80107044:	e9 b6 f7 ff ff       	jmp    801067ff <alltraps>

80107049 <vector98>:
.globl vector98
vector98:
  pushl $0
80107049:	6a 00                	push   $0x0
  pushl $98
8010704b:	6a 62                	push   $0x62
  jmp alltraps
8010704d:	e9 ad f7 ff ff       	jmp    801067ff <alltraps>

80107052 <vector99>:
.globl vector99
vector99:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $99
80107054:	6a 63                	push   $0x63
  jmp alltraps
80107056:	e9 a4 f7 ff ff       	jmp    801067ff <alltraps>

8010705b <vector100>:
.globl vector100
vector100:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $100
8010705d:	6a 64                	push   $0x64
  jmp alltraps
8010705f:	e9 9b f7 ff ff       	jmp    801067ff <alltraps>

80107064 <vector101>:
.globl vector101
vector101:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $101
80107066:	6a 65                	push   $0x65
  jmp alltraps
80107068:	e9 92 f7 ff ff       	jmp    801067ff <alltraps>

8010706d <vector102>:
.globl vector102
vector102:
  pushl $0
8010706d:	6a 00                	push   $0x0
  pushl $102
8010706f:	6a 66                	push   $0x66
  jmp alltraps
80107071:	e9 89 f7 ff ff       	jmp    801067ff <alltraps>

80107076 <vector103>:
.globl vector103
vector103:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $103
80107078:	6a 67                	push   $0x67
  jmp alltraps
8010707a:	e9 80 f7 ff ff       	jmp    801067ff <alltraps>

8010707f <vector104>:
.globl vector104
vector104:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $104
80107081:	6a 68                	push   $0x68
  jmp alltraps
80107083:	e9 77 f7 ff ff       	jmp    801067ff <alltraps>

80107088 <vector105>:
.globl vector105
vector105:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $105
8010708a:	6a 69                	push   $0x69
  jmp alltraps
8010708c:	e9 6e f7 ff ff       	jmp    801067ff <alltraps>

80107091 <vector106>:
.globl vector106
vector106:
  pushl $0
80107091:	6a 00                	push   $0x0
  pushl $106
80107093:	6a 6a                	push   $0x6a
  jmp alltraps
80107095:	e9 65 f7 ff ff       	jmp    801067ff <alltraps>

8010709a <vector107>:
.globl vector107
vector107:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $107
8010709c:	6a 6b                	push   $0x6b
  jmp alltraps
8010709e:	e9 5c f7 ff ff       	jmp    801067ff <alltraps>

801070a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $108
801070a5:	6a 6c                	push   $0x6c
  jmp alltraps
801070a7:	e9 53 f7 ff ff       	jmp    801067ff <alltraps>

801070ac <vector109>:
.globl vector109
vector109:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $109
801070ae:	6a 6d                	push   $0x6d
  jmp alltraps
801070b0:	e9 4a f7 ff ff       	jmp    801067ff <alltraps>

801070b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801070b5:	6a 00                	push   $0x0
  pushl $110
801070b7:	6a 6e                	push   $0x6e
  jmp alltraps
801070b9:	e9 41 f7 ff ff       	jmp    801067ff <alltraps>

801070be <vector111>:
.globl vector111
vector111:
  pushl $0
801070be:	6a 00                	push   $0x0
  pushl $111
801070c0:	6a 6f                	push   $0x6f
  jmp alltraps
801070c2:	e9 38 f7 ff ff       	jmp    801067ff <alltraps>

801070c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $112
801070c9:	6a 70                	push   $0x70
  jmp alltraps
801070cb:	e9 2f f7 ff ff       	jmp    801067ff <alltraps>

801070d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801070d0:	6a 00                	push   $0x0
  pushl $113
801070d2:	6a 71                	push   $0x71
  jmp alltraps
801070d4:	e9 26 f7 ff ff       	jmp    801067ff <alltraps>

801070d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801070d9:	6a 00                	push   $0x0
  pushl $114
801070db:	6a 72                	push   $0x72
  jmp alltraps
801070dd:	e9 1d f7 ff ff       	jmp    801067ff <alltraps>

801070e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801070e2:	6a 00                	push   $0x0
  pushl $115
801070e4:	6a 73                	push   $0x73
  jmp alltraps
801070e6:	e9 14 f7 ff ff       	jmp    801067ff <alltraps>

801070eb <vector116>:
.globl vector116
vector116:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $116
801070ed:	6a 74                	push   $0x74
  jmp alltraps
801070ef:	e9 0b f7 ff ff       	jmp    801067ff <alltraps>

801070f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $117
801070f6:	6a 75                	push   $0x75
  jmp alltraps
801070f8:	e9 02 f7 ff ff       	jmp    801067ff <alltraps>

801070fd <vector118>:
.globl vector118
vector118:
  pushl $0
801070fd:	6a 00                	push   $0x0
  pushl $118
801070ff:	6a 76                	push   $0x76
  jmp alltraps
80107101:	e9 f9 f6 ff ff       	jmp    801067ff <alltraps>

80107106 <vector119>:
.globl vector119
vector119:
  pushl $0
80107106:	6a 00                	push   $0x0
  pushl $119
80107108:	6a 77                	push   $0x77
  jmp alltraps
8010710a:	e9 f0 f6 ff ff       	jmp    801067ff <alltraps>

8010710f <vector120>:
.globl vector120
vector120:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $120
80107111:	6a 78                	push   $0x78
  jmp alltraps
80107113:	e9 e7 f6 ff ff       	jmp    801067ff <alltraps>

80107118 <vector121>:
.globl vector121
vector121:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $121
8010711a:	6a 79                	push   $0x79
  jmp alltraps
8010711c:	e9 de f6 ff ff       	jmp    801067ff <alltraps>

80107121 <vector122>:
.globl vector122
vector122:
  pushl $0
80107121:	6a 00                	push   $0x0
  pushl $122
80107123:	6a 7a                	push   $0x7a
  jmp alltraps
80107125:	e9 d5 f6 ff ff       	jmp    801067ff <alltraps>

8010712a <vector123>:
.globl vector123
vector123:
  pushl $0
8010712a:	6a 00                	push   $0x0
  pushl $123
8010712c:	6a 7b                	push   $0x7b
  jmp alltraps
8010712e:	e9 cc f6 ff ff       	jmp    801067ff <alltraps>

80107133 <vector124>:
.globl vector124
vector124:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $124
80107135:	6a 7c                	push   $0x7c
  jmp alltraps
80107137:	e9 c3 f6 ff ff       	jmp    801067ff <alltraps>

8010713c <vector125>:
.globl vector125
vector125:
  pushl $0
8010713c:	6a 00                	push   $0x0
  pushl $125
8010713e:	6a 7d                	push   $0x7d
  jmp alltraps
80107140:	e9 ba f6 ff ff       	jmp    801067ff <alltraps>

80107145 <vector126>:
.globl vector126
vector126:
  pushl $0
80107145:	6a 00                	push   $0x0
  pushl $126
80107147:	6a 7e                	push   $0x7e
  jmp alltraps
80107149:	e9 b1 f6 ff ff       	jmp    801067ff <alltraps>

8010714e <vector127>:
.globl vector127
vector127:
  pushl $0
8010714e:	6a 00                	push   $0x0
  pushl $127
80107150:	6a 7f                	push   $0x7f
  jmp alltraps
80107152:	e9 a8 f6 ff ff       	jmp    801067ff <alltraps>

80107157 <vector128>:
.globl vector128
vector128:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $128
80107159:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010715e:	e9 9c f6 ff ff       	jmp    801067ff <alltraps>

80107163 <vector129>:
.globl vector129
vector129:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $129
80107165:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010716a:	e9 90 f6 ff ff       	jmp    801067ff <alltraps>

8010716f <vector130>:
.globl vector130
vector130:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $130
80107171:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107176:	e9 84 f6 ff ff       	jmp    801067ff <alltraps>

8010717b <vector131>:
.globl vector131
vector131:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $131
8010717d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107182:	e9 78 f6 ff ff       	jmp    801067ff <alltraps>

80107187 <vector132>:
.globl vector132
vector132:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $132
80107189:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010718e:	e9 6c f6 ff ff       	jmp    801067ff <alltraps>

80107193 <vector133>:
.globl vector133
vector133:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $133
80107195:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010719a:	e9 60 f6 ff ff       	jmp    801067ff <alltraps>

8010719f <vector134>:
.globl vector134
vector134:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $134
801071a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071a6:	e9 54 f6 ff ff       	jmp    801067ff <alltraps>

801071ab <vector135>:
.globl vector135
vector135:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $135
801071ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801071b2:	e9 48 f6 ff ff       	jmp    801067ff <alltraps>

801071b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $136
801071b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801071be:	e9 3c f6 ff ff       	jmp    801067ff <alltraps>

801071c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $137
801071c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801071ca:	e9 30 f6 ff ff       	jmp    801067ff <alltraps>

801071cf <vector138>:
.globl vector138
vector138:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $138
801071d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801071d6:	e9 24 f6 ff ff       	jmp    801067ff <alltraps>

801071db <vector139>:
.globl vector139
vector139:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $139
801071dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071e2:	e9 18 f6 ff ff       	jmp    801067ff <alltraps>

801071e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $140
801071e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071ee:	e9 0c f6 ff ff       	jmp    801067ff <alltraps>

801071f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $141
801071f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071fa:	e9 00 f6 ff ff       	jmp    801067ff <alltraps>

801071ff <vector142>:
.globl vector142
vector142:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $142
80107201:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107206:	e9 f4 f5 ff ff       	jmp    801067ff <alltraps>

8010720b <vector143>:
.globl vector143
vector143:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $143
8010720d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107212:	e9 e8 f5 ff ff       	jmp    801067ff <alltraps>

80107217 <vector144>:
.globl vector144
vector144:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $144
80107219:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010721e:	e9 dc f5 ff ff       	jmp    801067ff <alltraps>

80107223 <vector145>:
.globl vector145
vector145:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $145
80107225:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010722a:	e9 d0 f5 ff ff       	jmp    801067ff <alltraps>

8010722f <vector146>:
.globl vector146
vector146:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $146
80107231:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107236:	e9 c4 f5 ff ff       	jmp    801067ff <alltraps>

8010723b <vector147>:
.globl vector147
vector147:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $147
8010723d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107242:	e9 b8 f5 ff ff       	jmp    801067ff <alltraps>

80107247 <vector148>:
.globl vector148
vector148:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $148
80107249:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010724e:	e9 ac f5 ff ff       	jmp    801067ff <alltraps>

80107253 <vector149>:
.globl vector149
vector149:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $149
80107255:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010725a:	e9 a0 f5 ff ff       	jmp    801067ff <alltraps>

8010725f <vector150>:
.globl vector150
vector150:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $150
80107261:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107266:	e9 94 f5 ff ff       	jmp    801067ff <alltraps>

8010726b <vector151>:
.globl vector151
vector151:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $151
8010726d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107272:	e9 88 f5 ff ff       	jmp    801067ff <alltraps>

80107277 <vector152>:
.globl vector152
vector152:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $152
80107279:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010727e:	e9 7c f5 ff ff       	jmp    801067ff <alltraps>

80107283 <vector153>:
.globl vector153
vector153:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $153
80107285:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010728a:	e9 70 f5 ff ff       	jmp    801067ff <alltraps>

8010728f <vector154>:
.globl vector154
vector154:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $154
80107291:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107296:	e9 64 f5 ff ff       	jmp    801067ff <alltraps>

8010729b <vector155>:
.globl vector155
vector155:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $155
8010729d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072a2:	e9 58 f5 ff ff       	jmp    801067ff <alltraps>

801072a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $156
801072a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801072ae:	e9 4c f5 ff ff       	jmp    801067ff <alltraps>

801072b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $157
801072b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801072ba:	e9 40 f5 ff ff       	jmp    801067ff <alltraps>

801072bf <vector158>:
.globl vector158
vector158:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $158
801072c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801072c6:	e9 34 f5 ff ff       	jmp    801067ff <alltraps>

801072cb <vector159>:
.globl vector159
vector159:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $159
801072cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072d2:	e9 28 f5 ff ff       	jmp    801067ff <alltraps>

801072d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $160
801072d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072de:	e9 1c f5 ff ff       	jmp    801067ff <alltraps>

801072e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $161
801072e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072ea:	e9 10 f5 ff ff       	jmp    801067ff <alltraps>

801072ef <vector162>:
.globl vector162
vector162:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $162
801072f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072f6:	e9 04 f5 ff ff       	jmp    801067ff <alltraps>

801072fb <vector163>:
.globl vector163
vector163:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $163
801072fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107302:	e9 f8 f4 ff ff       	jmp    801067ff <alltraps>

80107307 <vector164>:
.globl vector164
vector164:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $164
80107309:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010730e:	e9 ec f4 ff ff       	jmp    801067ff <alltraps>

80107313 <vector165>:
.globl vector165
vector165:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $165
80107315:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010731a:	e9 e0 f4 ff ff       	jmp    801067ff <alltraps>

8010731f <vector166>:
.globl vector166
vector166:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $166
80107321:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107326:	e9 d4 f4 ff ff       	jmp    801067ff <alltraps>

8010732b <vector167>:
.globl vector167
vector167:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $167
8010732d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107332:	e9 c8 f4 ff ff       	jmp    801067ff <alltraps>

80107337 <vector168>:
.globl vector168
vector168:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $168
80107339:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010733e:	e9 bc f4 ff ff       	jmp    801067ff <alltraps>

80107343 <vector169>:
.globl vector169
vector169:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $169
80107345:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010734a:	e9 b0 f4 ff ff       	jmp    801067ff <alltraps>

8010734f <vector170>:
.globl vector170
vector170:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $170
80107351:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107356:	e9 a4 f4 ff ff       	jmp    801067ff <alltraps>

8010735b <vector171>:
.globl vector171
vector171:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $171
8010735d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107362:	e9 98 f4 ff ff       	jmp    801067ff <alltraps>

80107367 <vector172>:
.globl vector172
vector172:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $172
80107369:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010736e:	e9 8c f4 ff ff       	jmp    801067ff <alltraps>

80107373 <vector173>:
.globl vector173
vector173:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $173
80107375:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010737a:	e9 80 f4 ff ff       	jmp    801067ff <alltraps>

8010737f <vector174>:
.globl vector174
vector174:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $174
80107381:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107386:	e9 74 f4 ff ff       	jmp    801067ff <alltraps>

8010738b <vector175>:
.globl vector175
vector175:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $175
8010738d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107392:	e9 68 f4 ff ff       	jmp    801067ff <alltraps>

80107397 <vector176>:
.globl vector176
vector176:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $176
80107399:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010739e:	e9 5c f4 ff ff       	jmp    801067ff <alltraps>

801073a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $177
801073a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073aa:	e9 50 f4 ff ff       	jmp    801067ff <alltraps>

801073af <vector178>:
.globl vector178
vector178:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $178
801073b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801073b6:	e9 44 f4 ff ff       	jmp    801067ff <alltraps>

801073bb <vector179>:
.globl vector179
vector179:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $179
801073bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801073c2:	e9 38 f4 ff ff       	jmp    801067ff <alltraps>

801073c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $180
801073c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073ce:	e9 2c f4 ff ff       	jmp    801067ff <alltraps>

801073d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $181
801073d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801073da:	e9 20 f4 ff ff       	jmp    801067ff <alltraps>

801073df <vector182>:
.globl vector182
vector182:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $182
801073e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073e6:	e9 14 f4 ff ff       	jmp    801067ff <alltraps>

801073eb <vector183>:
.globl vector183
vector183:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $183
801073ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073f2:	e9 08 f4 ff ff       	jmp    801067ff <alltraps>

801073f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $184
801073f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073fe:	e9 fc f3 ff ff       	jmp    801067ff <alltraps>

80107403 <vector185>:
.globl vector185
vector185:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $185
80107405:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010740a:	e9 f0 f3 ff ff       	jmp    801067ff <alltraps>

8010740f <vector186>:
.globl vector186
vector186:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $186
80107411:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107416:	e9 e4 f3 ff ff       	jmp    801067ff <alltraps>

8010741b <vector187>:
.globl vector187
vector187:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $187
8010741d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107422:	e9 d8 f3 ff ff       	jmp    801067ff <alltraps>

80107427 <vector188>:
.globl vector188
vector188:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $188
80107429:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010742e:	e9 cc f3 ff ff       	jmp    801067ff <alltraps>

80107433 <vector189>:
.globl vector189
vector189:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $189
80107435:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010743a:	e9 c0 f3 ff ff       	jmp    801067ff <alltraps>

8010743f <vector190>:
.globl vector190
vector190:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $190
80107441:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107446:	e9 b4 f3 ff ff       	jmp    801067ff <alltraps>

8010744b <vector191>:
.globl vector191
vector191:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $191
8010744d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107452:	e9 a8 f3 ff ff       	jmp    801067ff <alltraps>

80107457 <vector192>:
.globl vector192
vector192:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $192
80107459:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010745e:	e9 9c f3 ff ff       	jmp    801067ff <alltraps>

80107463 <vector193>:
.globl vector193
vector193:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $193
80107465:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010746a:	e9 90 f3 ff ff       	jmp    801067ff <alltraps>

8010746f <vector194>:
.globl vector194
vector194:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $194
80107471:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107476:	e9 84 f3 ff ff       	jmp    801067ff <alltraps>

8010747b <vector195>:
.globl vector195
vector195:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $195
8010747d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107482:	e9 78 f3 ff ff       	jmp    801067ff <alltraps>

80107487 <vector196>:
.globl vector196
vector196:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $196
80107489:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010748e:	e9 6c f3 ff ff       	jmp    801067ff <alltraps>

80107493 <vector197>:
.globl vector197
vector197:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $197
80107495:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010749a:	e9 60 f3 ff ff       	jmp    801067ff <alltraps>

8010749f <vector198>:
.globl vector198
vector198:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $198
801074a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074a6:	e9 54 f3 ff ff       	jmp    801067ff <alltraps>

801074ab <vector199>:
.globl vector199
vector199:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $199
801074ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801074b2:	e9 48 f3 ff ff       	jmp    801067ff <alltraps>

801074b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $200
801074b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801074be:	e9 3c f3 ff ff       	jmp    801067ff <alltraps>

801074c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $201
801074c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801074ca:	e9 30 f3 ff ff       	jmp    801067ff <alltraps>

801074cf <vector202>:
.globl vector202
vector202:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $202
801074d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801074d6:	e9 24 f3 ff ff       	jmp    801067ff <alltraps>

801074db <vector203>:
.globl vector203
vector203:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $203
801074dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074e2:	e9 18 f3 ff ff       	jmp    801067ff <alltraps>

801074e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $204
801074e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074ee:	e9 0c f3 ff ff       	jmp    801067ff <alltraps>

801074f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $205
801074f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074fa:	e9 00 f3 ff ff       	jmp    801067ff <alltraps>

801074ff <vector206>:
.globl vector206
vector206:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $206
80107501:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107506:	e9 f4 f2 ff ff       	jmp    801067ff <alltraps>

8010750b <vector207>:
.globl vector207
vector207:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $207
8010750d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107512:	e9 e8 f2 ff ff       	jmp    801067ff <alltraps>

80107517 <vector208>:
.globl vector208
vector208:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $208
80107519:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010751e:	e9 dc f2 ff ff       	jmp    801067ff <alltraps>

80107523 <vector209>:
.globl vector209
vector209:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $209
80107525:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010752a:	e9 d0 f2 ff ff       	jmp    801067ff <alltraps>

8010752f <vector210>:
.globl vector210
vector210:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $210
80107531:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107536:	e9 c4 f2 ff ff       	jmp    801067ff <alltraps>

8010753b <vector211>:
.globl vector211
vector211:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $211
8010753d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107542:	e9 b8 f2 ff ff       	jmp    801067ff <alltraps>

80107547 <vector212>:
.globl vector212
vector212:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $212
80107549:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010754e:	e9 ac f2 ff ff       	jmp    801067ff <alltraps>

80107553 <vector213>:
.globl vector213
vector213:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $213
80107555:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010755a:	e9 a0 f2 ff ff       	jmp    801067ff <alltraps>

8010755f <vector214>:
.globl vector214
vector214:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $214
80107561:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107566:	e9 94 f2 ff ff       	jmp    801067ff <alltraps>

8010756b <vector215>:
.globl vector215
vector215:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $215
8010756d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107572:	e9 88 f2 ff ff       	jmp    801067ff <alltraps>

80107577 <vector216>:
.globl vector216
vector216:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $216
80107579:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010757e:	e9 7c f2 ff ff       	jmp    801067ff <alltraps>

80107583 <vector217>:
.globl vector217
vector217:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $217
80107585:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010758a:	e9 70 f2 ff ff       	jmp    801067ff <alltraps>

8010758f <vector218>:
.globl vector218
vector218:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $218
80107591:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107596:	e9 64 f2 ff ff       	jmp    801067ff <alltraps>

8010759b <vector219>:
.globl vector219
vector219:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $219
8010759d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075a2:	e9 58 f2 ff ff       	jmp    801067ff <alltraps>

801075a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $220
801075a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801075ae:	e9 4c f2 ff ff       	jmp    801067ff <alltraps>

801075b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $221
801075b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801075ba:	e9 40 f2 ff ff       	jmp    801067ff <alltraps>

801075bf <vector222>:
.globl vector222
vector222:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $222
801075c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801075c6:	e9 34 f2 ff ff       	jmp    801067ff <alltraps>

801075cb <vector223>:
.globl vector223
vector223:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $223
801075cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075d2:	e9 28 f2 ff ff       	jmp    801067ff <alltraps>

801075d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $224
801075d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075de:	e9 1c f2 ff ff       	jmp    801067ff <alltraps>

801075e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $225
801075e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075ea:	e9 10 f2 ff ff       	jmp    801067ff <alltraps>

801075ef <vector226>:
.globl vector226
vector226:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $226
801075f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075f6:	e9 04 f2 ff ff       	jmp    801067ff <alltraps>

801075fb <vector227>:
.globl vector227
vector227:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $227
801075fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107602:	e9 f8 f1 ff ff       	jmp    801067ff <alltraps>

80107607 <vector228>:
.globl vector228
vector228:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $228
80107609:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010760e:	e9 ec f1 ff ff       	jmp    801067ff <alltraps>

80107613 <vector229>:
.globl vector229
vector229:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $229
80107615:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010761a:	e9 e0 f1 ff ff       	jmp    801067ff <alltraps>

8010761f <vector230>:
.globl vector230
vector230:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $230
80107621:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107626:	e9 d4 f1 ff ff       	jmp    801067ff <alltraps>

8010762b <vector231>:
.globl vector231
vector231:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $231
8010762d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107632:	e9 c8 f1 ff ff       	jmp    801067ff <alltraps>

80107637 <vector232>:
.globl vector232
vector232:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $232
80107639:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010763e:	e9 bc f1 ff ff       	jmp    801067ff <alltraps>

80107643 <vector233>:
.globl vector233
vector233:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $233
80107645:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010764a:	e9 b0 f1 ff ff       	jmp    801067ff <alltraps>

8010764f <vector234>:
.globl vector234
vector234:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $234
80107651:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107656:	e9 a4 f1 ff ff       	jmp    801067ff <alltraps>

8010765b <vector235>:
.globl vector235
vector235:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $235
8010765d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107662:	e9 98 f1 ff ff       	jmp    801067ff <alltraps>

80107667 <vector236>:
.globl vector236
vector236:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $236
80107669:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010766e:	e9 8c f1 ff ff       	jmp    801067ff <alltraps>

80107673 <vector237>:
.globl vector237
vector237:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $237
80107675:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010767a:	e9 80 f1 ff ff       	jmp    801067ff <alltraps>

8010767f <vector238>:
.globl vector238
vector238:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $238
80107681:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107686:	e9 74 f1 ff ff       	jmp    801067ff <alltraps>

8010768b <vector239>:
.globl vector239
vector239:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $239
8010768d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107692:	e9 68 f1 ff ff       	jmp    801067ff <alltraps>

80107697 <vector240>:
.globl vector240
vector240:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $240
80107699:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010769e:	e9 5c f1 ff ff       	jmp    801067ff <alltraps>

801076a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $241
801076a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076aa:	e9 50 f1 ff ff       	jmp    801067ff <alltraps>

801076af <vector242>:
.globl vector242
vector242:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $242
801076b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801076b6:	e9 44 f1 ff ff       	jmp    801067ff <alltraps>

801076bb <vector243>:
.globl vector243
vector243:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $243
801076bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801076c2:	e9 38 f1 ff ff       	jmp    801067ff <alltraps>

801076c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $244
801076c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076ce:	e9 2c f1 ff ff       	jmp    801067ff <alltraps>

801076d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $245
801076d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801076da:	e9 20 f1 ff ff       	jmp    801067ff <alltraps>

801076df <vector246>:
.globl vector246
vector246:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $246
801076e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076e6:	e9 14 f1 ff ff       	jmp    801067ff <alltraps>

801076eb <vector247>:
.globl vector247
vector247:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $247
801076ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076f2:	e9 08 f1 ff ff       	jmp    801067ff <alltraps>

801076f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $248
801076f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076fe:	e9 fc f0 ff ff       	jmp    801067ff <alltraps>

80107703 <vector249>:
.globl vector249
vector249:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $249
80107705:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010770a:	e9 f0 f0 ff ff       	jmp    801067ff <alltraps>

8010770f <vector250>:
.globl vector250
vector250:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $250
80107711:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107716:	e9 e4 f0 ff ff       	jmp    801067ff <alltraps>

8010771b <vector251>:
.globl vector251
vector251:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $251
8010771d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107722:	e9 d8 f0 ff ff       	jmp    801067ff <alltraps>

80107727 <vector252>:
.globl vector252
vector252:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $252
80107729:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010772e:	e9 cc f0 ff ff       	jmp    801067ff <alltraps>

80107733 <vector253>:
.globl vector253
vector253:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $253
80107735:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010773a:	e9 c0 f0 ff ff       	jmp    801067ff <alltraps>

8010773f <vector254>:
.globl vector254
vector254:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $254
80107741:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107746:	e9 b4 f0 ff ff       	jmp    801067ff <alltraps>

8010774b <vector255>:
.globl vector255
vector255:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $255
8010774d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107752:	e9 a8 f0 ff ff       	jmp    801067ff <alltraps>
80107757:	66 90                	xchg   %ax,%ax
80107759:	66 90                	xchg   %ax,%ax
8010775b:	66 90                	xchg   %ax,%ax
8010775d:	66 90                	xchg   %ax,%ax
8010775f:	90                   	nop

80107760 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	56                   	push   %esi
80107765:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107766:	89 d3                	mov    %edx,%ebx
{
80107768:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010776a:	c1 eb 16             	shr    $0x16,%ebx
8010776d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107770:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107773:	8b 06                	mov    (%esi),%eax
80107775:	a8 01                	test   $0x1,%al
80107777:	74 27                	je     801077a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107779:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010777e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107784:	c1 ef 0a             	shr    $0xa,%edi
}
80107787:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010778a:	89 fa                	mov    %edi,%edx
8010778c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107792:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107795:	5b                   	pop    %ebx
80107796:	5e                   	pop    %esi
80107797:	5f                   	pop    %edi
80107798:	5d                   	pop    %ebp
80107799:	c3                   	ret    
8010779a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801077a0:	85 c9                	test   %ecx,%ecx
801077a2:	74 2c                	je     801077d0 <walkpgdir+0x70>
801077a4:	e8 27 ad ff ff       	call   801024d0 <kalloc>
801077a9:	85 c0                	test   %eax,%eax
801077ab:	89 c3                	mov    %eax,%ebx
801077ad:	74 21                	je     801077d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801077af:	83 ec 04             	sub    $0x4,%esp
801077b2:	68 00 10 00 00       	push   $0x1000
801077b7:	6a 00                	push   $0x0
801077b9:	50                   	push   %eax
801077ba:	e8 a1 da ff ff       	call   80105260 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077c5:	83 c4 10             	add    $0x10,%esp
801077c8:	83 c8 07             	or     $0x7,%eax
801077cb:	89 06                	mov    %eax,(%esi)
801077cd:	eb b5                	jmp    80107784 <walkpgdir+0x24>
801077cf:	90                   	nop
}
801077d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801077d3:	31 c0                	xor    %eax,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    
801077da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801077e6:	89 d3                	mov    %edx,%ebx
801077e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801077ee:	83 ec 1c             	sub    $0x1c,%esp
801077f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801077f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801077f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801077fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107800:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107803:	8b 45 0c             	mov    0xc(%ebp),%eax
80107806:	29 df                	sub    %ebx,%edi
80107808:	83 c8 01             	or     $0x1,%eax
8010780b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010780e:	eb 15                	jmp    80107825 <mappages+0x45>
    if(*pte & PTE_P)
80107810:	f6 00 01             	testb  $0x1,(%eax)
80107813:	75 45                	jne    8010785a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107815:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107818:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010781b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010781d:	74 31                	je     80107850 <mappages+0x70>
      break;
    a += PGSIZE;
8010781f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107828:	b9 01 00 00 00       	mov    $0x1,%ecx
8010782d:	89 da                	mov    %ebx,%edx
8010782f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107832:	e8 29 ff ff ff       	call   80107760 <walkpgdir>
80107837:	85 c0                	test   %eax,%eax
80107839:	75 d5                	jne    80107810 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010783b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010783e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107843:	5b                   	pop    %ebx
80107844:	5e                   	pop    %esi
80107845:	5f                   	pop    %edi
80107846:	5d                   	pop    %ebp
80107847:	c3                   	ret    
80107848:	90                   	nop
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107853:	31 c0                	xor    %eax,%eax
}
80107855:	5b                   	pop    %ebx
80107856:	5e                   	pop    %esi
80107857:	5f                   	pop    %edi
80107858:	5d                   	pop    %ebp
80107859:	c3                   	ret    
      panic("remap");
8010785a:	83 ec 0c             	sub    $0xc,%esp
8010785d:	68 00 8b 10 80       	push   $0x80108b00
80107862:	e8 29 8b ff ff       	call   80100390 <panic>
80107867:	89 f6                	mov    %esi,%esi
80107869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107870 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107876:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010787c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010787e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107884:	83 ec 1c             	sub    $0x1c,%esp
80107887:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010788a:	39 d3                	cmp    %edx,%ebx
8010788c:	73 66                	jae    801078f4 <deallocuvm.part.0+0x84>
8010788e:	89 d6                	mov    %edx,%esi
80107890:	eb 3d                	jmp    801078cf <deallocuvm.part.0+0x5f>
80107892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107898:	8b 10                	mov    (%eax),%edx
8010789a:	f6 c2 01             	test   $0x1,%dl
8010789d:	74 26                	je     801078c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010789f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801078a5:	74 58                	je     801078ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801078a7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801078aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801078b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801078b3:	52                   	push   %edx
801078b4:	e8 67 aa ff ff       	call   80102320 <kfree>
      *pte = 0;
801078b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078bc:	83 c4 10             	add    $0x10,%esp
801078bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801078c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078cb:	39 f3                	cmp    %esi,%ebx
801078cd:	73 25                	jae    801078f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801078cf:	31 c9                	xor    %ecx,%ecx
801078d1:	89 da                	mov    %ebx,%edx
801078d3:	89 f8                	mov    %edi,%eax
801078d5:	e8 86 fe ff ff       	call   80107760 <walkpgdir>
    if(!pte)
801078da:	85 c0                	test   %eax,%eax
801078dc:	75 ba                	jne    80107898 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801078de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801078e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801078ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078f0:	39 f3                	cmp    %esi,%ebx
801078f2:	72 db                	jb     801078cf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801078f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078fa:	5b                   	pop    %ebx
801078fb:	5e                   	pop    %esi
801078fc:	5f                   	pop    %edi
801078fd:	5d                   	pop    %ebp
801078fe:	c3                   	ret    
        panic("kfree");
801078ff:	83 ec 0c             	sub    $0xc,%esp
80107902:	68 06 83 10 80       	push   $0x80108306
80107907:	e8 84 8a ff ff       	call   80100390 <panic>
8010790c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107910 <seginit>:
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107916:	e8 05 c0 ff ff       	call   80103920 <cpuid>
8010791b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107921:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107926:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010792a:	c7 80 b8 3c 11 80 ff 	movl   $0xffff,-0x7feec348(%eax)
80107931:	ff 00 00 
80107934:	c7 80 bc 3c 11 80 00 	movl   $0xcf9a00,-0x7feec344(%eax)
8010793b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010793e:	c7 80 c0 3c 11 80 ff 	movl   $0xffff,-0x7feec340(%eax)
80107945:	ff 00 00 
80107948:	c7 80 c4 3c 11 80 00 	movl   $0xcf9200,-0x7feec33c(%eax)
8010794f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107952:	c7 80 c8 3c 11 80 ff 	movl   $0xffff,-0x7feec338(%eax)
80107959:	ff 00 00 
8010795c:	c7 80 cc 3c 11 80 00 	movl   $0xcffa00,-0x7feec334(%eax)
80107963:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107966:	c7 80 d0 3c 11 80 ff 	movl   $0xffff,-0x7feec330(%eax)
8010796d:	ff 00 00 
80107970:	c7 80 d4 3c 11 80 00 	movl   $0xcff200,-0x7feec32c(%eax)
80107977:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010797a:	05 b0 3c 11 80       	add    $0x80113cb0,%eax
  pd[1] = (uint)p;
8010797f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107983:	c1 e8 10             	shr    $0x10,%eax
80107986:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010798a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010798d:	0f 01 10             	lgdtl  (%eax)
}
80107990:	c9                   	leave  
80107991:	c3                   	ret    
80107992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079a0:	a1 e4 39 13 80       	mov    0x801339e4,%eax
{
801079a5:	55                   	push   %ebp
801079a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079ad:	0f 22 d8             	mov    %eax,%cr3
}
801079b0:	5d                   	pop    %ebp
801079b1:	c3                   	ret    
801079b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <switchuvm>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 1c             	sub    $0x1c,%esp
801079c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801079cc:	85 db                	test   %ebx,%ebx
801079ce:	0f 84 cb 00 00 00    	je     80107a9f <switchuvm+0xdf>
  if(p->kstack == 0)
801079d4:	8b 43 08             	mov    0x8(%ebx),%eax
801079d7:	85 c0                	test   %eax,%eax
801079d9:	0f 84 da 00 00 00    	je     80107ab9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801079df:	8b 43 04             	mov    0x4(%ebx),%eax
801079e2:	85 c0                	test   %eax,%eax
801079e4:	0f 84 c2 00 00 00    	je     80107aac <switchuvm+0xec>
  pushcli();
801079ea:	e8 91 d6 ff ff       	call   80105080 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079ef:	e8 ac be ff ff       	call   801038a0 <mycpu>
801079f4:	89 c6                	mov    %eax,%esi
801079f6:	e8 a5 be ff ff       	call   801038a0 <mycpu>
801079fb:	89 c7                	mov    %eax,%edi
801079fd:	e8 9e be ff ff       	call   801038a0 <mycpu>
80107a02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a05:	83 c7 08             	add    $0x8,%edi
80107a08:	e8 93 be ff ff       	call   801038a0 <mycpu>
80107a0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a10:	83 c0 08             	add    $0x8,%eax
80107a13:	ba 67 00 00 00       	mov    $0x67,%edx
80107a18:	c1 e8 18             	shr    $0x18,%eax
80107a1b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107a22:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107a29:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a2f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a34:	83 c1 08             	add    $0x8,%ecx
80107a37:	c1 e9 10             	shr    $0x10,%ecx
80107a3a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107a40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a45:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a4c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107a51:	e8 4a be ff ff       	call   801038a0 <mycpu>
80107a56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a5d:	e8 3e be ff ff       	call   801038a0 <mycpu>
80107a62:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a66:	8b 73 08             	mov    0x8(%ebx),%esi
80107a69:	e8 32 be ff ff       	call   801038a0 <mycpu>
80107a6e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a74:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a77:	e8 24 be ff ff       	call   801038a0 <mycpu>
80107a7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a80:	b8 28 00 00 00       	mov    $0x28,%eax
80107a85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107a88:	8b 43 04             	mov    0x4(%ebx),%eax
80107a8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a90:	0f 22 d8             	mov    %eax,%cr3
}
80107a93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a96:	5b                   	pop    %ebx
80107a97:	5e                   	pop    %esi
80107a98:	5f                   	pop    %edi
80107a99:	5d                   	pop    %ebp
  popcli();
80107a9a:	e9 21 d6 ff ff       	jmp    801050c0 <popcli>
    panic("switchuvm: no process");
80107a9f:	83 ec 0c             	sub    $0xc,%esp
80107aa2:	68 06 8b 10 80       	push   $0x80108b06
80107aa7:	e8 e4 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107aac:	83 ec 0c             	sub    $0xc,%esp
80107aaf:	68 31 8b 10 80       	push   $0x80108b31
80107ab4:	e8 d7 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107ab9:	83 ec 0c             	sub    $0xc,%esp
80107abc:	68 1c 8b 10 80       	push   $0x80108b1c
80107ac1:	e8 ca 88 ff ff       	call   80100390 <panic>
80107ac6:	8d 76 00             	lea    0x0(%esi),%esi
80107ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ad0 <inituvm>:
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
80107ad5:	53                   	push   %ebx
80107ad6:	83 ec 1c             	sub    $0x1c,%esp
80107ad9:	8b 75 10             	mov    0x10(%ebp),%esi
80107adc:	8b 45 08             	mov    0x8(%ebp),%eax
80107adf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107ae2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107ae8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107aeb:	77 49                	ja     80107b36 <inituvm+0x66>
  mem = kalloc();
80107aed:	e8 de a9 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80107af2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107af5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107af7:	68 00 10 00 00       	push   $0x1000
80107afc:	6a 00                	push   $0x0
80107afe:	50                   	push   %eax
80107aff:	e8 5c d7 ff ff       	call   80105260 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b04:	58                   	pop    %eax
80107b05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b10:	5a                   	pop    %edx
80107b11:	6a 06                	push   $0x6
80107b13:	50                   	push   %eax
80107b14:	31 d2                	xor    %edx,%edx
80107b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b19:	e8 c2 fc ff ff       	call   801077e0 <mappages>
  memmove(mem, init, sz);
80107b1e:	89 75 10             	mov    %esi,0x10(%ebp)
80107b21:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107b24:	83 c4 10             	add    $0x10,%esp
80107b27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b2d:	5b                   	pop    %ebx
80107b2e:	5e                   	pop    %esi
80107b2f:	5f                   	pop    %edi
80107b30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b31:	e9 da d7 ff ff       	jmp    80105310 <memmove>
    panic("inituvm: more than a page");
80107b36:	83 ec 0c             	sub    $0xc,%esp
80107b39:	68 45 8b 10 80       	push   $0x80108b45
80107b3e:	e8 4d 88 ff ff       	call   80100390 <panic>
80107b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b50 <loaduvm>:
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	56                   	push   %esi
80107b55:	53                   	push   %ebx
80107b56:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107b59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107b60:	0f 85 91 00 00 00    	jne    80107bf7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107b66:	8b 75 18             	mov    0x18(%ebp),%esi
80107b69:	31 db                	xor    %ebx,%ebx
80107b6b:	85 f6                	test   %esi,%esi
80107b6d:	75 1a                	jne    80107b89 <loaduvm+0x39>
80107b6f:	eb 6f                	jmp    80107be0 <loaduvm+0x90>
80107b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107b84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107b87:	76 57                	jbe    80107be0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b89:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b8f:	31 c9                	xor    %ecx,%ecx
80107b91:	01 da                	add    %ebx,%edx
80107b93:	e8 c8 fb ff ff       	call   80107760 <walkpgdir>
80107b98:	85 c0                	test   %eax,%eax
80107b9a:	74 4e                	je     80107bea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107b9c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107ba1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ba6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107bab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107bb1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107bb4:	01 d9                	add    %ebx,%ecx
80107bb6:	05 00 00 00 80       	add    $0x80000000,%eax
80107bbb:	57                   	push   %edi
80107bbc:	51                   	push   %ecx
80107bbd:	50                   	push   %eax
80107bbe:	ff 75 10             	pushl  0x10(%ebp)
80107bc1:	e8 aa 9d ff ff       	call   80101970 <readi>
80107bc6:	83 c4 10             	add    $0x10,%esp
80107bc9:	39 f8                	cmp    %edi,%eax
80107bcb:	74 ab                	je     80107b78 <loaduvm+0x28>
}
80107bcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bd5:	5b                   	pop    %ebx
80107bd6:	5e                   	pop    %esi
80107bd7:	5f                   	pop    %edi
80107bd8:	5d                   	pop    %ebp
80107bd9:	c3                   	ret    
80107bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107be3:	31 c0                	xor    %eax,%eax
}
80107be5:	5b                   	pop    %ebx
80107be6:	5e                   	pop    %esi
80107be7:	5f                   	pop    %edi
80107be8:	5d                   	pop    %ebp
80107be9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107bea:	83 ec 0c             	sub    $0xc,%esp
80107bed:	68 5f 8b 10 80       	push   $0x80108b5f
80107bf2:	e8 99 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107bf7:	83 ec 0c             	sub    $0xc,%esp
80107bfa:	68 00 8c 10 80       	push   $0x80108c00
80107bff:	e8 8c 87 ff ff       	call   80100390 <panic>
80107c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c10 <allocuvm>:
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	57                   	push   %edi
80107c14:	56                   	push   %esi
80107c15:	53                   	push   %ebx
80107c16:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107c19:	8b 7d 10             	mov    0x10(%ebp),%edi
80107c1c:	85 ff                	test   %edi,%edi
80107c1e:	0f 88 8e 00 00 00    	js     80107cb2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107c24:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107c27:	0f 82 93 00 00 00    	jb     80107cc0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c30:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107c36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107c3c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107c3f:	0f 86 7e 00 00 00    	jbe    80107cc3 <allocuvm+0xb3>
80107c45:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107c48:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c4b:	eb 42                	jmp    80107c8f <allocuvm+0x7f>
80107c4d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107c50:	83 ec 04             	sub    $0x4,%esp
80107c53:	68 00 10 00 00       	push   $0x1000
80107c58:	6a 00                	push   $0x0
80107c5a:	50                   	push   %eax
80107c5b:	e8 00 d6 ff ff       	call   80105260 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107c60:	58                   	pop    %eax
80107c61:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107c67:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c6c:	5a                   	pop    %edx
80107c6d:	6a 06                	push   $0x6
80107c6f:	50                   	push   %eax
80107c70:	89 da                	mov    %ebx,%edx
80107c72:	89 f8                	mov    %edi,%eax
80107c74:	e8 67 fb ff ff       	call   801077e0 <mappages>
80107c79:	83 c4 10             	add    $0x10,%esp
80107c7c:	85 c0                	test   %eax,%eax
80107c7e:	78 50                	js     80107cd0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107c80:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c86:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107c89:	0f 86 81 00 00 00    	jbe    80107d10 <allocuvm+0x100>
    mem = kalloc();
80107c8f:	e8 3c a8 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80107c94:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107c96:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107c98:	75 b6                	jne    80107c50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107c9a:	83 ec 0c             	sub    $0xc,%esp
80107c9d:	68 7d 8b 10 80       	push   $0x80108b7d
80107ca2:	e8 b9 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107ca7:	83 c4 10             	add    $0x10,%esp
80107caa:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cad:	39 45 10             	cmp    %eax,0x10(%ebp)
80107cb0:	77 6e                	ja     80107d20 <allocuvm+0x110>
}
80107cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107cb5:	31 ff                	xor    %edi,%edi
}
80107cb7:	89 f8                	mov    %edi,%eax
80107cb9:	5b                   	pop    %ebx
80107cba:	5e                   	pop    %esi
80107cbb:	5f                   	pop    %edi
80107cbc:	5d                   	pop    %ebp
80107cbd:	c3                   	ret    
80107cbe:	66 90                	xchg   %ax,%ax
    return oldsz;
80107cc0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cc6:	89 f8                	mov    %edi,%eax
80107cc8:	5b                   	pop    %ebx
80107cc9:	5e                   	pop    %esi
80107cca:	5f                   	pop    %edi
80107ccb:	5d                   	pop    %ebp
80107ccc:	c3                   	ret    
80107ccd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107cd0:	83 ec 0c             	sub    $0xc,%esp
80107cd3:	68 95 8b 10 80       	push   $0x80108b95
80107cd8:	e8 83 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107cdd:	83 c4 10             	add    $0x10,%esp
80107ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce3:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ce6:	76 0d                	jbe    80107cf5 <allocuvm+0xe5>
80107ce8:	89 c1                	mov    %eax,%ecx
80107cea:	8b 55 10             	mov    0x10(%ebp),%edx
80107ced:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf0:	e8 7b fb ff ff       	call   80107870 <deallocuvm.part.0>
      kfree(mem);
80107cf5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107cf8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107cfa:	56                   	push   %esi
80107cfb:	e8 20 a6 ff ff       	call   80102320 <kfree>
      return 0;
80107d00:	83 c4 10             	add    $0x10,%esp
}
80107d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d06:	89 f8                	mov    %edi,%eax
80107d08:	5b                   	pop    %ebx
80107d09:	5e                   	pop    %esi
80107d0a:	5f                   	pop    %edi
80107d0b:	5d                   	pop    %ebp
80107d0c:	c3                   	ret    
80107d0d:	8d 76 00             	lea    0x0(%esi),%esi
80107d10:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d16:	5b                   	pop    %ebx
80107d17:	89 f8                	mov    %edi,%eax
80107d19:	5e                   	pop    %esi
80107d1a:	5f                   	pop    %edi
80107d1b:	5d                   	pop    %ebp
80107d1c:	c3                   	ret    
80107d1d:	8d 76 00             	lea    0x0(%esi),%esi
80107d20:	89 c1                	mov    %eax,%ecx
80107d22:	8b 55 10             	mov    0x10(%ebp),%edx
80107d25:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107d28:	31 ff                	xor    %edi,%edi
80107d2a:	e8 41 fb ff ff       	call   80107870 <deallocuvm.part.0>
80107d2f:	eb 92                	jmp    80107cc3 <allocuvm+0xb3>
80107d31:	eb 0d                	jmp    80107d40 <deallocuvm>
80107d33:	90                   	nop
80107d34:	90                   	nop
80107d35:	90                   	nop
80107d36:	90                   	nop
80107d37:	90                   	nop
80107d38:	90                   	nop
80107d39:	90                   	nop
80107d3a:	90                   	nop
80107d3b:	90                   	nop
80107d3c:	90                   	nop
80107d3d:	90                   	nop
80107d3e:	90                   	nop
80107d3f:	90                   	nop

80107d40 <deallocuvm>:
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107d4c:	39 d1                	cmp    %edx,%ecx
80107d4e:	73 10                	jae    80107d60 <deallocuvm+0x20>
}
80107d50:	5d                   	pop    %ebp
80107d51:	e9 1a fb ff ff       	jmp    80107870 <deallocuvm.part.0>
80107d56:	8d 76 00             	lea    0x0(%esi),%esi
80107d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107d60:	89 d0                	mov    %edx,%eax
80107d62:	5d                   	pop    %ebp
80107d63:	c3                   	ret    
80107d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d70:	55                   	push   %ebp
80107d71:	89 e5                	mov    %esp,%ebp
80107d73:	57                   	push   %edi
80107d74:	56                   	push   %esi
80107d75:	53                   	push   %ebx
80107d76:	83 ec 0c             	sub    $0xc,%esp
80107d79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d7c:	85 f6                	test   %esi,%esi
80107d7e:	74 59                	je     80107dd9 <freevm+0x69>
80107d80:	31 c9                	xor    %ecx,%ecx
80107d82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107d87:	89 f0                	mov    %esi,%eax
80107d89:	e8 e2 fa ff ff       	call   80107870 <deallocuvm.part.0>
80107d8e:	89 f3                	mov    %esi,%ebx
80107d90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d96:	eb 0f                	jmp    80107da7 <freevm+0x37>
80107d98:	90                   	nop
80107d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107da0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107da3:	39 fb                	cmp    %edi,%ebx
80107da5:	74 23                	je     80107dca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107da7:	8b 03                	mov    (%ebx),%eax
80107da9:	a8 01                	test   $0x1,%al
80107dab:	74 f3                	je     80107da0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107dad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107db2:	83 ec 0c             	sub    $0xc,%esp
80107db5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107db8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107dbd:	50                   	push   %eax
80107dbe:	e8 5d a5 ff ff       	call   80102320 <kfree>
80107dc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107dc6:	39 fb                	cmp    %edi,%ebx
80107dc8:	75 dd                	jne    80107da7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107dca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dd0:	5b                   	pop    %ebx
80107dd1:	5e                   	pop    %esi
80107dd2:	5f                   	pop    %edi
80107dd3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107dd4:	e9 47 a5 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80107dd9:	83 ec 0c             	sub    $0xc,%esp
80107ddc:	68 b1 8b 10 80       	push   $0x80108bb1
80107de1:	e8 aa 85 ff ff       	call   80100390 <panic>
80107de6:	8d 76 00             	lea    0x0(%esi),%esi
80107de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107df0 <setupkvm>:
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	56                   	push   %esi
80107df4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107df5:	e8 d6 a6 ff ff       	call   801024d0 <kalloc>
80107dfa:	85 c0                	test   %eax,%eax
80107dfc:	89 c6                	mov    %eax,%esi
80107dfe:	74 42                	je     80107e42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107e00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e03:	bb 20 b8 10 80       	mov    $0x8010b820,%ebx
  memset(pgdir, 0, PGSIZE);
80107e08:	68 00 10 00 00       	push   $0x1000
80107e0d:	6a 00                	push   $0x0
80107e0f:	50                   	push   %eax
80107e10:	e8 4b d4 ff ff       	call   80105260 <memset>
80107e15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107e18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107e1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e1e:	83 ec 08             	sub    $0x8,%esp
80107e21:	8b 13                	mov    (%ebx),%edx
80107e23:	ff 73 0c             	pushl  0xc(%ebx)
80107e26:	50                   	push   %eax
80107e27:	29 c1                	sub    %eax,%ecx
80107e29:	89 f0                	mov    %esi,%eax
80107e2b:	e8 b0 f9 ff ff       	call   801077e0 <mappages>
80107e30:	83 c4 10             	add    $0x10,%esp
80107e33:	85 c0                	test   %eax,%eax
80107e35:	78 19                	js     80107e50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e37:	83 c3 10             	add    $0x10,%ebx
80107e3a:	81 fb 60 b8 10 80    	cmp    $0x8010b860,%ebx
80107e40:	75 d6                	jne    80107e18 <setupkvm+0x28>
}
80107e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e45:	89 f0                	mov    %esi,%eax
80107e47:	5b                   	pop    %ebx
80107e48:	5e                   	pop    %esi
80107e49:	5d                   	pop    %ebp
80107e4a:	c3                   	ret    
80107e4b:	90                   	nop
80107e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107e50:	83 ec 0c             	sub    $0xc,%esp
80107e53:	56                   	push   %esi
      return 0;
80107e54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e56:	e8 15 ff ff ff       	call   80107d70 <freevm>
      return 0;
80107e5b:	83 c4 10             	add    $0x10,%esp
}
80107e5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e61:	89 f0                	mov    %esi,%eax
80107e63:	5b                   	pop    %ebx
80107e64:	5e                   	pop    %esi
80107e65:	5d                   	pop    %ebp
80107e66:	c3                   	ret    
80107e67:	89 f6                	mov    %esi,%esi
80107e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e70 <kvmalloc>:
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e76:	e8 75 ff ff ff       	call   80107df0 <setupkvm>
80107e7b:	a3 e4 39 13 80       	mov    %eax,0x801339e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e80:	05 00 00 00 80       	add    $0x80000000,%eax
80107e85:	0f 22 d8             	mov    %eax,%cr3
}
80107e88:	c9                   	leave  
80107e89:	c3                   	ret    
80107e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e91:	31 c9                	xor    %ecx,%ecx
{
80107e93:	89 e5                	mov    %esp,%ebp
80107e95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e98:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9e:	e8 bd f8 ff ff       	call   80107760 <walkpgdir>
  if(pte == 0)
80107ea3:	85 c0                	test   %eax,%eax
80107ea5:	74 05                	je     80107eac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ea7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107eaa:	c9                   	leave  
80107eab:	c3                   	ret    
    panic("clearpteu");
80107eac:	83 ec 0c             	sub    $0xc,%esp
80107eaf:	68 c2 8b 10 80       	push   $0x80108bc2
80107eb4:	e8 d7 84 ff ff       	call   80100390 <panic>
80107eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ec0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107ec9:	e8 22 ff ff ff       	call   80107df0 <setupkvm>
80107ece:	85 c0                	test   %eax,%eax
80107ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ed3:	0f 84 9f 00 00 00    	je     80107f78 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107edc:	85 c9                	test   %ecx,%ecx
80107ede:	0f 84 94 00 00 00    	je     80107f78 <copyuvm+0xb8>
80107ee4:	31 ff                	xor    %edi,%edi
80107ee6:	eb 4a                	jmp    80107f32 <copyuvm+0x72>
80107ee8:	90                   	nop
80107ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107ef0:	83 ec 04             	sub    $0x4,%esp
80107ef3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107ef9:	68 00 10 00 00       	push   $0x1000
80107efe:	53                   	push   %ebx
80107eff:	50                   	push   %eax
80107f00:	e8 0b d4 ff ff       	call   80105310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107f05:	58                   	pop    %eax
80107f06:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f0c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f11:	5a                   	pop    %edx
80107f12:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f15:	50                   	push   %eax
80107f16:	89 fa                	mov    %edi,%edx
80107f18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f1b:	e8 c0 f8 ff ff       	call   801077e0 <mappages>
80107f20:	83 c4 10             	add    $0x10,%esp
80107f23:	85 c0                	test   %eax,%eax
80107f25:	78 61                	js     80107f88 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107f27:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107f2d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107f30:	76 46                	jbe    80107f78 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f32:	8b 45 08             	mov    0x8(%ebp),%eax
80107f35:	31 c9                	xor    %ecx,%ecx
80107f37:	89 fa                	mov    %edi,%edx
80107f39:	e8 22 f8 ff ff       	call   80107760 <walkpgdir>
80107f3e:	85 c0                	test   %eax,%eax
80107f40:	74 61                	je     80107fa3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107f42:	8b 00                	mov    (%eax),%eax
80107f44:	a8 01                	test   $0x1,%al
80107f46:	74 4e                	je     80107f96 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107f48:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107f4a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107f4f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107f55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107f58:	e8 73 a5 ff ff       	call   801024d0 <kalloc>
80107f5d:	85 c0                	test   %eax,%eax
80107f5f:	89 c6                	mov    %eax,%esi
80107f61:	75 8d                	jne    80107ef0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107f63:	83 ec 0c             	sub    $0xc,%esp
80107f66:	ff 75 e0             	pushl  -0x20(%ebp)
80107f69:	e8 02 fe ff ff       	call   80107d70 <freevm>
  return 0;
80107f6e:	83 c4 10             	add    $0x10,%esp
80107f71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f7e:	5b                   	pop    %ebx
80107f7f:	5e                   	pop    %esi
80107f80:	5f                   	pop    %edi
80107f81:	5d                   	pop    %ebp
80107f82:	c3                   	ret    
80107f83:	90                   	nop
80107f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107f88:	83 ec 0c             	sub    $0xc,%esp
80107f8b:	56                   	push   %esi
80107f8c:	e8 8f a3 ff ff       	call   80102320 <kfree>
      goto bad;
80107f91:	83 c4 10             	add    $0x10,%esp
80107f94:	eb cd                	jmp    80107f63 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107f96:	83 ec 0c             	sub    $0xc,%esp
80107f99:	68 e6 8b 10 80       	push   $0x80108be6
80107f9e:	e8 ed 83 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107fa3:	83 ec 0c             	sub    $0xc,%esp
80107fa6:	68 cc 8b 10 80       	push   $0x80108bcc
80107fab:	e8 e0 83 ff ff       	call   80100390 <panic>

80107fb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107fb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fb1:	31 c9                	xor    %ecx,%ecx
{
80107fb3:	89 e5                	mov    %esp,%ebp
80107fb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbe:	e8 9d f7 ff ff       	call   80107760 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107fc3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107fc5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107fc6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107fc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107fcd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107fd0:	05 00 00 00 80       	add    $0x80000000,%eax
80107fd5:	83 fa 05             	cmp    $0x5,%edx
80107fd8:	ba 00 00 00 00       	mov    $0x0,%edx
80107fdd:	0f 45 c2             	cmovne %edx,%eax
}
80107fe0:	c3                   	ret    
80107fe1:	eb 0d                	jmp    80107ff0 <copyout>
80107fe3:	90                   	nop
80107fe4:	90                   	nop
80107fe5:	90                   	nop
80107fe6:	90                   	nop
80107fe7:	90                   	nop
80107fe8:	90                   	nop
80107fe9:	90                   	nop
80107fea:	90                   	nop
80107feb:	90                   	nop
80107fec:	90                   	nop
80107fed:	90                   	nop
80107fee:	90                   	nop
80107fef:	90                   	nop

80107ff0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	57                   	push   %edi
80107ff4:	56                   	push   %esi
80107ff5:	53                   	push   %ebx
80107ff6:	83 ec 1c             	sub    $0x1c,%esp
80107ff9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108002:	85 db                	test   %ebx,%ebx
80108004:	75 40                	jne    80108046 <copyout+0x56>
80108006:	eb 70                	jmp    80108078 <copyout+0x88>
80108008:	90                   	nop
80108009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108010:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108013:	89 f1                	mov    %esi,%ecx
80108015:	29 d1                	sub    %edx,%ecx
80108017:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010801d:	39 d9                	cmp    %ebx,%ecx
8010801f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108022:	29 f2                	sub    %esi,%edx
80108024:	83 ec 04             	sub    $0x4,%esp
80108027:	01 d0                	add    %edx,%eax
80108029:	51                   	push   %ecx
8010802a:	57                   	push   %edi
8010802b:	50                   	push   %eax
8010802c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010802f:	e8 dc d2 ff ff       	call   80105310 <memmove>
    len -= n;
    buf += n;
80108034:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108037:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010803a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108040:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108042:	29 cb                	sub    %ecx,%ebx
80108044:	74 32                	je     80108078 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108046:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108048:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010804b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010804e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108054:	56                   	push   %esi
80108055:	ff 75 08             	pushl  0x8(%ebp)
80108058:	e8 53 ff ff ff       	call   80107fb0 <uva2ka>
    if(pa0 == 0)
8010805d:	83 c4 10             	add    $0x10,%esp
80108060:	85 c0                	test   %eax,%eax
80108062:	75 ac                	jne    80108010 <copyout+0x20>
  }
  return 0;
}
80108064:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010806c:	5b                   	pop    %ebx
8010806d:	5e                   	pop    %esi
8010806e:	5f                   	pop    %edi
8010806f:	5d                   	pop    %ebp
80108070:	c3                   	ret    
80108071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108078:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010807b:	31 c0                	xor    %eax,%eax
}
8010807d:	5b                   	pop    %ebx
8010807e:	5e                   	pop    %esi
8010807f:	5f                   	pop    %edi
80108080:	5d                   	pop    %ebp
80108081:	c3                   	ret    
