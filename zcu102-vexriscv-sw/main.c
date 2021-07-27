#include <stdint.h>

#if 1
#define CSR_MSTATUS_MIE 0x8

#define CSR_IRQ_MASK 0xBC0
#define CSR_IRQ_PENDING 0xFC0

#define CSR_DCACHE_INFO 0xCC0

static inline unsigned int irq_pending(void)
{
	unsigned int pending;
	asm volatile ("csrr %0, %1" : "=r"(pending) : "i"(CSR_IRQ_PENDING));
	return pending;
}

static inline unsigned int irq_getmask(void)
{
	unsigned int mask;
	asm volatile ("csrr %0, %1" : "=r"(mask) : "i"(CSR_IRQ_MASK));
	return mask;
}
#endif

void main() {
	uint32_t counter = 0;
	while (1)
	{
		*(volatile uint32_t *)0x90000000 = counter;
		asm volatile("wfi");
		counter += 1;
	}
}

void irqCallback()
{
#if 1
    unsigned int irqs;
    irqs = irq_pending() & irq_getmask();
    *(volatile uint32_t *)0x90000004 = irqs;
#endif
}



